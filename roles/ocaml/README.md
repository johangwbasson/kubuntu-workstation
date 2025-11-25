# OCaml Role

This role installs OCaml and its ecosystem tools on Kubuntu 24.04.

## What Gets Installed

### System Dependencies
- build-essential
- curl, git, m4, unzip
- bubblewrap (for opam sandboxing)
- pkg-config
- libgmp-dev, libffi-dev, libssl-dev

### OCaml Tools
- **opam** - OCaml Package Manager (v2.2)
- **OCaml compiler** - Version 5.2.1 (configurable)

#### Core Tools (installed via: `opam install dune merlin ocaml-lsp-server ocamlformat`)
- **dune** - Modern build system for OCaml
- **merlin** - Editor helper for autocompletion and type information
- **ocaml-lsp-server** - Language Server Protocol implementation for IDE integration
- **ocamlformat** - Code formatter

#### Additional Tools
- **utop** - Enhanced interactive REPL
- **ocp-indent** - Indentation tool

### Common Libraries
- **base** & **core** - Alternative standard libraries
- **lwt** - Promises and concurrent programming
- **cmdliner** - Command-line parsing
- **yojson** - JSON parsing
- **alcotest** - Testing framework

## Configuration

Key variables in `defaults/main.yml`:

```yaml
ocaml_version: "5.2.1"           # OCaml compiler version
opam_version: "2.2"              # opam version
ocaml_configure_shell: true      # Auto-configure shell integration
```

## Usage

### Run the role

```bash
# Install OCaml and all tools
ansible-playbook workstation.yml --tags ocaml

# Install only OCaml without libraries
ansible-playbook workstation.yml --tags ocaml,packages,development
```

### After Installation

The role automatically configures your shell (zsh/fish) with opam environment.

To verify installation:

```bash
# Check versions
ocaml -version
opam --version
dune --version

# Start the REPL
utop

# Create a new project
dune init project my_project
cd my_project
dune build
dune exec my_project
```

### Using with VSCode

The role installs `ocaml-lsp-server`. Install the OCaml Platform extension in VSCode:

```bash
code --install-extension ocamllabs.ocaml-platform
```

### Managing Packages

```bash
# Search for packages
opam search <package-name>

# Install a package
opam install <package-name>

# List installed packages
opam list

# Update package repository
opam update

# Upgrade packages
opam upgrade
```

## Security

- System packages installed from official Ubuntu repositories
- opam installer downloaded from official GitHub repository over HTTPS
- All OCaml packages installed via opam from official opam repository

## Idempotency

- Checks if opam is already installed before downloading
- Checks if opam is initialized before running init
- Only installs packages that aren't already installed
- Shell configuration only added if not already present
