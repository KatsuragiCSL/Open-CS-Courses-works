use crate::dwarf_data::{DwarfData, Error as DwarfError};
use nix::sys::ptrace;
use nix::sys::signal;
use nix::sys::wait::{waitpid, WaitPidFlag, WaitStatus};
use nix::unistd::Pid;
use std::process::{Command, Child};
use std::os::unix::process::CommandExt;

pub enum Status {
    /// Indicates inferior stopped. Contains the signal that stopped the process, as well as the
    /// current instruction pointer that it is stopped at.
    Stopped(signal::Signal, usize),

    /// Indicates inferior exited normally. Contains the exit status code.
    Exited(i32),

    /// Indicates the inferior exited due to a signal. Contains the signal that killed the
    /// process.
    Signaled(signal::Signal),
}

/// This function calls ptrace with PTRACE_TRACEME to enable debugging on a process. You should use
/// pre_exec with Command to call this in the child process.
fn child_traceme() -> Result<(), std::io::Error> {
    ptrace::traceme().or(Err(std::io::Error::new(
        std::io::ErrorKind::Other,
        "ptrace TRACEME failed",
    )))
}

pub struct Inferior {
    child: Child,
}

impl Inferior {
    /// Attempts to start a new inferior process. Returns Some(Inferior) if successful, or None if
    /// an error is encountered.
    pub fn new(target: &str, args: &Vec<String>) -> Option<Inferior> {
		let mut cmd = Command::new(target);
		cmd.args(args);
		unsafe {
			cmd.pre_exec(child_traceme);
		}
		let child = cmd.spawn().ok()?;
		let inf = Inferior {child: child};
		let status = inf.wait(Some(WaitPidFlag::WSTOPPED)).ok()?;
		match (status) {
			Status::Stopped(_, _) => {
			},
			_ => {
				println!("Children is not stopped.");
				return None
			}
		}
		Some(inf)
    }

    /// Returns the pid of this inferior.
    pub fn pid(&self) -> Pid {
        nix::unistd::Pid::from_raw(self.child.id() as i32)
    }

    /// Calls waitpid on this inferior and returns a Status to indicate the state of the process
    /// after the waitpid call.
    pub fn wait(&self, options: Option<WaitPidFlag>) -> Result<Status, nix::Error> {
        Ok(match waitpid(self.pid(), options)? {
            WaitStatus::Exited(_pid, exit_code) => Status::Exited(exit_code),
            WaitStatus::Signaled(_pid, signal, _core_dumped) => Status::Signaled(signal),
            WaitStatus::Stopped(_pid, signal) => {
                let regs = ptrace::getregs(self.pid())?;
                Status::Stopped(signal, regs.rip as usize)
            }
            other => panic!("waitpid returned unexpected status: {:?}", other),
        })
    }
	
	pub fn cont(&self) -> Result<Status, nix::Error> {
		ptrace::cont(self.pid(), None);
		let status = self.wait(None).ok().unwrap();
		Ok(status)
	}

	pub fn kill(&mut self) -> Result<(), nix::Error> {
		self.child.kill().ok();
		self.wait(None).ok();
		Ok(())
	}
	
	pub fn print_backtrace(&self, dwarf_data: &DwarfData) -> Result<(), nix::Error> {
		let regs = ptrace::getregs(self.pid())?;
		let mut rip = regs.rip as usize;
		let mut rbp = regs.rbp as usize;
		loop {
			let line = dwarf_data.get_line_from_addr(rip as usize);
			let func = dwarf_data.get_function_from_addr(rip as usize);
			match (&line, &func) {
				(Some(_line), Some(_func)) => println!("{} ({}:{})", _func, _line.file, _line.number),
				_ => println!("Unknown function or cannot get line number."),
			}

			match (&func) {
				Some(_func) => {
					if _func == "main" {
						break;
					}
				},
				None => {},
			}
			rip = ptrace::read(self.pid(), (rbp+8) as ptrace::AddressType)? as usize;
			rbp = ptrace::read(self.pid(), rbp as ptrace::AddressType)? as usize;
		}
		//println!("$rip: {:#x}", regs.rip);
		Ok(())
	}
}
