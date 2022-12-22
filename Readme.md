# Draw Language (Now windows only)

## About the project

This is a homework which implements a language. The language is for drawing.

## Requirements

- make(in path)
- gcc(in path)
- bison
- flex
- python3 with matplotlib(in path)

## Grammar

### General

- Statements are seprated with `;`.

- Statements are case insensitive.

- Comments are started with `//` and ended with `\n`.

- `<expression>` is a expression which can be calculated supporting sin, cos, tan, exp, ln and constant PI and E.

- `<t_expression>` is a `<expression>` optionally with the variable `t`.

### Statements

- `ORIGIN IS (expression,expression)`

- `SCALE IS (expression,expression)`

- `SCALE IS AUTO`

- `ROT IS expression`

- `FOR T FROM expression TO expression STEP expression DRAW (t_expression,t_expression)`

#### only for interactive mode

- `SLEEP expression`

- `EXIT`

- `CLEAR`

## How to use

1. Install all the requirements on your computer.
2. Change the `PYTHON` and `PYTHON_VERSION` variable in the `Makefile` to your python path and subversion.
3. Run `make` in the root directory of the project.
4. Run `./build/draw` to start interactive mode or `./build/draw <sourcefile> [targetfile]` to run a file.
