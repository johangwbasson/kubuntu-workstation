# OCaml Quick Start Guide

## Installation

The role has been added to your workstation playbook. To install OCaml:

```bash
ansible-playbook workstation.yml --tags ocaml
```

## Your First OCaml Program

### 1. Create a new project

```bash
dune init project hello_world
cd hello_world
```

This creates:
```
hello_world/
├── bin/
│   ├── dune
│   └── main.ml
├── lib/
│   └── dune
├── test/
│   └── hello_world.ml
├── dune-project
└── hello_world.opam
```

### 2. Build and run

```bash
# Build the project
dune build

# Run the executable
dune exec hello_world

# Build and run in one command
dune exec hello_world
```

### 3. Interactive development with utop

```bash
# Start utop (enhanced REPL)
utop

# Load your library in utop
#require "hello_world";;
```

## Common Dune Commands

```bash
dune build              # Build the project
dune clean              # Clean build artifacts
dune exec <name>        # Run an executable
dune test               # Run tests
dune runtest            # Run tests and show diff
dune fmt                # Format code with ocamlformat
dune build --watch      # Watch mode - rebuild on file changes
```

## Example: Simple OCaml Program

Edit `bin/main.ml`:

```ocaml
let greet name =
  Printf.printf "Hello, %s!\n" name

let () =
  greet "OCaml Developer"
```

Build and run:
```bash
dune exec hello_world
# Output: Hello, OCaml Developer!
```

## Using Libraries

### Install a library

```bash
opam install <library-name>
```

### Add to your project

Edit `bin/dune`:

```lisp
(executable
 (name main)
 (libraries hello_world lwt yojson))
```

### Example with libraries

```ocaml
(* Using lwt for async *)
open Lwt.Syntax

let fetch_data () =
  let* () = Lwt_unix.sleep 1.0 in
  Lwt.return "Data fetched!"

let () =
  let result = Lwt_main.run (fetch_data ()) in
  print_endline result
```

## Testing with Alcotest

Create `test/test_hello.ml`:

```ocaml
let test_greeting () =
  let expected = "Hello, World!" in
  let actual = "Hello, World!" in
  Alcotest.(check string) "same string" expected actual

let () =
  let open Alcotest in
  run "Hello Tests" [
    "greetings", [
      test_case "Basic greeting" `Quick test_greeting;
    ];
  ]
```

Run tests:
```bash
dune test
```

## IDE Setup

### VSCode
1. Install OCaml Platform extension: `ocamllabs.ocaml-platform`
2. The role already installed `ocaml-lsp-server`
3. Features: autocomplete, type hints, go-to-definition, formatting

### Neovim/Vim
The role installed Merlin. Add to your config:
```vim
" For vim-plug
Plug 'ocaml/merlin'
```

## Useful Resources

- [Official OCaml Documentation](https://ocaml.org/docs)
- [Real World OCaml Book](https://dev.realworldocaml.org/)
- [Dune Documentation](https://dune.readthedocs.io/)
- [OCaml Discourse Forum](https://discuss.ocaml.org/)

## Troubleshooting

### opam environment not loaded

```bash
# Manually load opam environment
eval $(opam env)
```

### Reinstall a package

```bash
opam reinstall <package-name>
```

### Update all packages

```bash
opam update
opam upgrade
```

### Switch OCaml versions

```bash
# List available compilers
opam switch list-available

# Create a new switch with different version
opam switch create 4.14.0

# Switch between compiler versions
opam switch 5.2.1
eval $(opam env)
```
