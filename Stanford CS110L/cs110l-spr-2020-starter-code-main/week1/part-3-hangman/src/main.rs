// Simple Hangman Program
// User gets five incorrect guesses
// Word chosen randomly from words.txt
// Inspiration from: https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html
// This assignment will introduce you to some fundamental syntax in Rust:
// - variable declaration
// - string manipulation
// - conditional statements
// - loops
// - vectors
// - files
// - user input
// We've tried to limit/hide Rust's quirks since we'll discuss those details
// more in depth in the coming lectures.
extern crate rand;
use rand::Rng;
use std::fs;
use std::io;
use std::io::Write;
use std::collections::HashSet;

const NUM_INCORRECT_GUESSES: u32 = 5;
const WORDS_PATH: &str = "words.txt";

fn pick_a_random_word() -> String {
    let file_string = fs::read_to_string(WORDS_PATH).expect("Unable to read file.");
    let words: Vec<&str> = file_string.split('\n').collect();
    String::from(words[rand::thread_rng().gen_range(0, words.len())].trim())
}

fn print_guess_left(guess_left: u32) {
	println!("You have {} guesses left", guess_left);
}

fn print_guessed_words(guessed_words: &HashSet<char>) {
	println!("You have guessed the following letters:");
	for c in guessed_words {
		print!("{}", c);
	}
	println!("");
}

fn print_revealed_words(revealed_words: &Vec<char>) {
	print!("The word so far is ");
	for c in revealed_words {
		print!("{}", c);
	}
	println!("");
}

fn game_loop(secret_word: &String, mut chance: u32) {
		let secret_word_chars: Vec<char> = secret_word.chars().collect();
		let mut revealed_words =  Vec::new();
		let mut guessed_words = HashSet::new();
		let mut not_guessed_words = HashSet::new();
		for i in 0..secret_word_chars.len() {
			revealed_words.push('_');
			not_guessed_words.insert(secret_word_chars[i]);
		}
		loop {
			print_revealed_words(&revealed_words);

			print_guessed_words(&guessed_words);

			print_guess_left(chance);

			print!("Please guess a letter: ");
			// Make sure the prompt from the previous line gets displayed:
			io::stdout()
				.flush()
				.expect("Error flushing stdout.");
			let mut guess = String::new();
			io::stdin()
				.read_line(&mut guess)
				.expect("Error reading line.");

			//preventing more than 1 chars in input
			let tmp: Vec<char> = guess.chars().collect();
			let guess_char = tmp[0];
			if (not_guessed_words.contains(&guess_char)) {
				not_guessed_words.remove(&guess_char);
				guessed_words.insert(guess_char);
				for i in 0..secret_word_chars.len() {
					if secret_word_chars[i] == guess_char {
						revealed_words[i] = guess_char;
					}
				}
			} else {
				chance -= 1;
				println!("Sorry, that letter is not in the word");
			}

			if (chance == 0) {
				println!("Sorry, you ran out of guesses!");
				break;
			}
			if (not_guessed_words.is_empty()) {
				println!("Congratulations you guessed the secret word: {}", secret_word);
				break;
			}
	}
}

fn main() {
    let secret_word = pick_a_random_word();
    // Note: given what you know about Rust so far, it's easier to pull characters out of a
    // vector than it is to pull them out of a string. You can get the ith character of
    // secret_word by doing secret_word_chars[i].
    let secret_word_chars: Vec<char> = secret_word.chars().collect();
    // Uncomment for debugging:
     println!("random word: {}", secret_word);

    // Your code here! :)
	let mut chance: u32 = NUM_INCORRECT_GUESSES;

	println!("Welcome to CS110L Hangman!");
	game_loop(&secret_word, chance);
}
