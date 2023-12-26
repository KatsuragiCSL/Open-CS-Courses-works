use crate::debugger_command::DebuggerCommand;
use crate::dwarf_data::{DwarfData, Error as DwarfError};
use crate::inferior::Inferior;
use crate::inferior::Status;
use rustyline::error::ReadlineError;
use rustyline::Editor;

pub struct Debugger {
    target: String,
    history_path: String,
    readline: Editor<()>,
    inferior: Option<Inferior>,
	debug_data: DwarfData,
}

impl Debugger {
    /// Initializes the debugger.
    pub fn new(target: &str) -> Debugger {
		let debug_data = match DwarfData::from_file(target) {
			Ok(val) => val,
			Err(DwarfError::ErrorOpeningFile) => {
				println!("Could not open file {}", target);
				std::process::exit(1);
			}
			Err(DwarfError::DwarfFormatError(err)) => {
				println!("Could not debugging symbols from {}: {:?}", target, err);
				std::process::exit(1);
			}
		};
		
        let history_path = format!("{}/.deet_history", std::env::var("HOME").unwrap());
        let mut readline = Editor::<()>::new();
        // Attempt to load history from ~/.deet_history if it exists
        let _ = readline.load_history(&history_path);

        Debugger {
            target: target.to_string(),
            history_path,
            readline,
            inferior: None,
			debug_data: debug_data,
        }
    }

    pub fn run(&mut self) {
        loop {
            match self.get_next_command() {
                DebuggerCommand::Run(args) => {
					// kill existing processes
					if self.inferior.is_some() {
						let mut inf = self.inferior.as_mut().unwrap();
						let killed = inf.kill();
						match (killed) {
							Ok(_) => {
								println!("Killed running inferior pid {}", inf.pid());
								self.inferior = None;
							},
							Err(_) => {
								println!("Error occured when killing inferior pid {}", inf.pid());
							}
						}
					}
                    if let Some(inferior) = Inferior::new(&self.target, &args) {
                        // Create the inferior
                        self.inferior = Some(inferior);
                        // You may use self.inferior.as_mut().unwrap() to get a mutable reference
                        // to the Inferior object
						let inf = self.inferior.as_mut().unwrap();
						// continue executing until stopped or terminated
						let status = inf.cont().ok().unwrap();
						match (status) {
							Status::Exited(exit_code) => {
								println!("Child exited (status {})", exit_code);
								return;
							},
							Status::Stopped(signal, rip) => {
								println!("Child stopped (signal {})", signal);
								// print stopped location in source.
								let debug_data = &self.debug_data;
								let line = debug_data.get_line_from_addr(rip as usize);
								match line {
									Some(_line) => {
										println!("Stopped at {}:{}", _line.file, _line.number);
									},
									None => {}
								}
							},
							_ => {
								return;
							}
						}
                    } else {
                        println!("Error starting subprocess");
                    }
                },
				DebuggerCommand::Continue => {
					if self.inferior.is_none() {
						println!("Error: no running process.");
					} else {
						let inf = self.inferior.as_mut().unwrap();
						let status = inf.cont().ok().unwrap();
						match (status) {
							Status::Exited(exit_code) => {
								println!("Child exited (status {})", exit_code);
								return;
							},
							Status::Stopped(signal, rip) => {
								println!("Child stopped (signal {})", signal);
								// print stopped location in source.
								let debug_data = &self.debug_data;
								let line = debug_data.get_line_from_addr(rip as usize);
								match line {
									Some(_line) => {
										println!("Stopped at {}:{}", _line.file, _line.number);
									},
									None => {}
								}
							},
							_ => {
								return;
							}
						}
					}
					
				},
				DebuggerCommand::Backtrace => {
					if self.inferior.is_none() {
						println!("Error: no running process.");
					} else {
						let inf = self.inferior.as_mut().unwrap();
						inf.print_backtrace(&self.debug_data);
					}
				}
                DebuggerCommand::Quit => {
					// kill existing processes
					if self.inferior.is_some() {
						let mut inf = self.inferior.as_mut().unwrap();
						let killed = inf.kill();
						match (killed) {
							Ok(_) => {
								println!("Killed running inferior pid {}", inf.pid());
								self.inferior = None;
							},
							Err(_) => {
								println!("Error occured when killing inferior pid {}", inf.pid());
							}
						}
					}
                    return;
                }
            }
        }
    }

    /// This function prompts the user to enter a command, and continues re-prompting until the user
    /// enters a valid command. It uses DebuggerCommand::from_tokens to do the command parsing.
    ///
    /// You don't need to read, understand, or modify this function.
    fn get_next_command(&mut self) -> DebuggerCommand {
        loop {
            // Print prompt and get next line of user input
            match self.readline.readline("(deet) ") {
                Err(ReadlineError::Interrupted) => {
                    // User pressed ctrl+c. We're going to ignore it
                    println!("Type \"quit\" to exit");
                }
                Err(ReadlineError::Eof) => {
                    // User pressed ctrl+d, which is the equivalent of "quit" for our purposes
                    return DebuggerCommand::Quit;
                }
                Err(err) => {
                    panic!("Unexpected I/O error: {:?}", err);
                }
                Ok(line) => {
                    if line.trim().len() == 0 {
                        continue;
                    }
                    self.readline.add_history_entry(line.as_str());
                    if let Err(err) = self.readline.save_history(&self.history_path) {
                        println!(
                            "Warning: failed to save history file at {}: {}",
                            self.history_path, err
                        );
                    }
                    let tokens: Vec<&str> = line.split_whitespace().collect();
                    if let Some(cmd) = DebuggerCommand::from_tokens(&tokens) {
                        return cmd;
                    } else {
                        println!("Unrecognized command.");
                    }
                }
            }
        }
    }
}
