/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * boolean type
 */
#include <stdbool.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  // -- TODO --
  unsigned int hash = 0;
  while (*string != '\0') {
    hash = hash * 31 + (int)(*string);
    string++;
  }

  return hash;
}

/*
 * This should return a nonzero value if the two strings are identical
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  if (strcmp(string1, string2) == 0) {
    return 1;
  }
  return 0;
}

/*
 * This function should read in every word from unsigned int hash = the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE *file;
  file = fopen(dictName, "r");
  if (file == NULL) {
    fprintf(stderr, "%s\n", "The file does not exist.");
  }
  else {
    char *buf = calloc(60, sizeof(char));
    while(fscanf(file, "%s", buf) != EOF) {
      char *key = (char *)malloc((strlen(buf) + 1));
      strcpy(key, buf);
      insertData(dictionary, key, key);
    }
    free(buf);
  }
  fclose(file);
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard
 * dictionary was used and the string "this is a taest of  this-proGram"
 * was given to stdin, the output to stdout should be
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
  char buf[60];
  // curr position
  int pos = 0;
  // curr char
  char c;
  char * sic = " [sic]";
  // 3 cases: exact word, all but first letter -> lowercase, all letters -> lowercase
  bool need_sic;
  while (c = getchar()) {
    // if input is alphabets, save it. else,
    if (isalpha(c)) {
      buf[pos] = c;
      pos++;
    }
    else {
      // end the word
      buf[pos] = '\0';

      // check whether no alphabets at all
      if (pos != 0) {
        fprintf(stdout, "%s", buf);
        // print new line if a word followed by punctuation
        /*if (c == '!' || c == '?' || c == ',' || c == '.') {
          putchar('\n');
        }*/
        char tmp[60];
        strcpy(tmp, buf);
        need_sic = true;

        if (findData(dictionary, tmp) != NULL) {
          need_sic = false;
        }

        // all but first alphabets -> lowercase
        for (int i = 1; tmp[i] != '\0'; i++) {
          tmp[i] = tolower(tmp[i]);
        }
        if (findData(dictionary, tmp) != NULL) {
          need_sic = false;
        }
        //all alphabets -> lowercase
        tmp[0] = tolower(tmp[0]);
        if (findData(dictionary, tmp) != NULL) {
          need_sic = false;
        }

        if (need_sic) {
          fprintf(stdout, "%s", sic);
        }
      }

      // reset curr position
      pos = 0;
      if (c == EOF) {
        break;
      }
      else {
        putchar(c);
      }
    }
  }
}
