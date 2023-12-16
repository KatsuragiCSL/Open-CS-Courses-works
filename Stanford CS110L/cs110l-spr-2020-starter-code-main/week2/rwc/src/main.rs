use std::env;
use std::fs::File;
use std::io::{self, BufRead};
use std::io::Read;
use std::process;

fn count_characters(filename: &String) -> Result<usize, io::Error> {
	let file = File::open(filename)?;
	let mut buffer = Vec::new();
	let ret = io::BufReader::new(file).read_to_end(&mut buffer)?;
	Ok(ret)
}

fn count_words(filename: &String) -> Result<usize, io::Error> {
	let file = File::open(filename)?;
	let mut ret: usize = 0;
	for _ in io::BufReader::new(file).split(b' ') {
		ret += 1;
	}
	Ok(ret)
}

fn count_lines(filename: &String) -> Result<usize, io::Error> {
	let file = File::open(filename)?;
	let mut ret: usize = 0;
	for _ in io::BufReader::new(file).lines() {
		ret += 1;
	}
	Ok(ret)
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Too few arguments.");
        process::exit(1);
    }
    let filename = &args[1];
    // Your code here :)
	println!("{}", count_characters(&filename).expect("counting chars"));
	println!("{}", count_words(&filename).expect("counting words"));
	println!("{}", count_lines(&filename).expect("counting lines"));
}
