# Q1: Custom Command (mygrep.sh)

A simplified Bash script mimicking basic `grep` functionality, supporting case-insensitive search, line numbering, and inverted matches.

---

## Features
- **Case-insensitive search**: Matches patterns regardless of case (e.g., "HELLO" or "hello").
- **Command-line options**:
  - `-n`: Display line numbers for matches.
  - `-v`: Invert matches (show non-matching lines).
  - `-vn`/`-nv`: Combine `-v` and `-n` (order-agnostic).
- **Input validation**: Checks for missing arguments or files.
- **Output style**: Mimics `grep`'s formatting.

---

## 1. Create Script

1. Create the script in file `mygrep.sh`

Make it executable:
 ```
chmod +x mygrep.sh
 ```
Usage
 ```
./mygrep.sh [OPTIONS] PATTERN FILE
 ```
Examples
Command	Description
- ```./mygrep.sh hello testfile.txt```	: Basic case-insensitive search.
- ```./mygrep.sh -n hello testfile.txt```	: Show matches with line numbers.
- ```./mygrep.sh -vn hello testfile.txt```	: Show non-matching lines with line numbers.
- ```./mygrep.sh --help```	: Display usage instructions.

---

Validation Tests
Test your script with `testfile.txt`:
```
# Create testfile.txt
echo "Hello world
This is a test
another test line
HELLO AGAIN
Don't match this line
Testing one two three
```
## 2. Test Commands
1. Basic Search
```
./mygrep.sh hello testfile.txt
```

Output:
```
Hello world
HELLO AGAIN
```
2. Line Numbers
```
./mygrep.sh -n hello testfile.txt
```
Output:
```
1:Hello world
4:HELLO AGAIN
```
3. Inverted Match
```
./mygrep.sh -vn hello testfile.txt
```
Output:
```
2:This is a test
3:another test line
5:Don't match this line
6:Testing one two three
```
4. Missing Search String
```
./mygrep.sh -v testfile.txt
```
Error:
```
Error: Missing search string or file.
```
---

  ![Screenshot (94)](https://github.com/user-attachments/assets/16528bf4-896d-41b3-8fc9-1d8cc8bc32f5)


## 3. Reflective Section
   
a) How your script handles arguments and options
- "The script first checks if `--help` is requested. Then, it parses options like `-n` and `-v`. After parsing, it expects a search string and a filename. It validates if the file exists and reads each line, matching or excluding based on options. It supports combined options like -vn or -nv."

b) If supporting regex / `-i` / `-c` / `-l`, how structure changes
- "If supporting regex, I'd need to allow full `grep -E` syntax. For -i (case-insensitive), it's already handled with `-i` flag in grep. For `-c` (count matches) or `-l` (list filename only if matching), I'd add variables to track matches and control output after processing."

c) Hardest part
- "Parsing multiple combined options like -vn was tricky. Also ensuring correct behavior with inverted matches and line numbering together took careful handling."


✅ Bonus Features included:

- --help support

- Option parsing with clear handling

