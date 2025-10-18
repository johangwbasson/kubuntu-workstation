# Rust Ansible Role

Idempotent Ansible role to install Rust programming language toolchain (Rustup, Cargo) along with useful cargo tools like Topgrade and cargo-update on Ubuntu/Kubuntu systems.

## Features

- ✅ **Fully Idempotent**: Safe to run multiple times without changes
- ✅ **User-Specific Installation**: Installs in user's home directory (no sudo required for Rust usage)
- ✅ **Shell Integration**: Automatic PATH configuration for Bash and Fish
- ✅ **Toolchain Management**: Uses official Rustup for easy updates
- ✅ **Essential Tools**: Includes Topgrade (universal updater) and cargo-update
- ✅ **Extensible**: Easy to add additional cargo tools
- ✅ **Environment Isolation**: Proper CARGO_HOME and RUSTUP_HOME setup

## Requirements

- Ubuntu/Kubuntu 24.04 (or compatible)
- Ansible 2.9 or higher
- Root/sudo access (for installing build dependencies)
- User account defined in `vars.yml` (`username` variable)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# User to install Rust for (from vars.yml)
rust_user: "{{ username }}"
rust_user_home: "{{ user_home }}"

# Rustup installation
rustup_init_url: https://sh.rustup.rs
rustup_profile: default  # minimal, default, complete
rust_toolchain: stable   # stable, beta, nightly, or specific version (1.70.0)

# Cargo home directory
cargo_home: "{{ rust_user_home }}/.cargo"
rustup_home: "{{ rust_user_home }}/.rustup"

# Cargo tools to install
rust_install_topgrade: true
rust_install_cargo_update: true

# Additional cargo tools (optional)
rust_additional_tools: []
# Examples:
# - ripgrep
# - bat
# - fd-find
# - exa
# - starship

# Shell integration
rust_add_to_bashrc: true
rust_add_to_fish: true

# Environment variables
rust_env_vars:
  CARGO_HOME: "{{ cargo_home }}"
  RUSTUP_HOME: "{{ rustup_home }}"
```

## Dependencies

None. This role installs its own dependencies (curl, build-essential, pkg-config, libssl-dev).

## What Gets Installed

### Core Components

1. **Rustup**: Official Rust toolchain installer
2. **Rust**: Rust compiler (rustc)
3. **Cargo**: Rust package manager and build tool

### Optional Tools (enabled by default)

1. **topgrade**: Universal system upgrade tool
   - Updates system packages (apt, snap, flatpak)
   - Updates Rust toolchains and cargo packages
   - Updates programming language tools (npm, pip, etc.)
   - Updates git repositories and more

2. **cargo-update** (cargo-install-update): Keep cargo-installed binaries up to date
   - `cargo install-update -a` updates all installed cargo tools
   - `cargo install-update -l` lists installed tools with versions

### Additional Tools (opt-in)

Configure via `rust_additional_tools` variable:
- `ripgrep`: Fast grep alternative
- `bat`: Cat with syntax highlighting
- `fd-find`: Fast find alternative
- `exa`: Modern ls replacement
- `starship`: Cross-shell prompt
- And many more from crates.io

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  become: true
  roles:
    - rust
```

### Custom Configuration

```yaml
- hosts: localhost
  become: true
  roles:
    - role: rust
      vars:
        rust_toolchain: nightly           # Use nightly instead of stable
        rust_install_topgrade: false      # Don't install topgrade
        rust_additional_tools:            # Install extra tools
          - ripgrep
          - bat
          - fd-find
          - exa
          - starship
```

### Minimal Installation

```yaml
- hosts: localhost
  become: true
  roles:
    - role: rust
      vars:
        rustup_profile: minimal            # Minimal Rust installation
        rust_install_topgrade: false       # Skip topgrade
        rust_install_cargo_update: false   # Skip cargo-update
```

### With Tags

```yaml
# Install only Rust/Rustup (skip tools)
ansible-playbook playbook.yml --tags rust,rustup

# Install everything
ansible-playbook playbook.yml --tags rust

# Update Rust toolchain only
ansible-playbook playbook.yml --tags update
```

## Installation Process

This role performs the following steps:

1. **Install dependencies** (curl, build-essential, pkg-config, libssl-dev)
2. **Check if Rustup exists** (idempotency check)
3. **Download Rustup installer** (if not installed)
4. **Install Rustup** (with specified profile and toolchain)
5. **Configure environment** (CARGO_HOME, RUSTUP_HOME)
6. **Add to shell PATH** (Bash and/or Fish)
7. **Update Rust toolchain** (ensure latest stable/nightly)
8. **Install cargo-update** (if enabled)
9. **Install topgrade** (if enabled)
10. **Install additional tools** (if specified)
11. **Verify installation** (check versions)
12. **Display helpful information** (commands, tips, resources)

## Idempotency Guarantees

This role ensures idempotent behavior through:

- **Rustup Installation**: Checks for existing rustup binary before downloading
  - Uses `creates: "{{ cargo_home }}/bin/rustup"` parameter
  - Only runs installer if rustup doesn't exist

- **Cargo Tools**: Checks if each tool is installed before attempting installation
  - Runs `cargo install` only if tool command fails
  - Uses tool-specific version checks

- **Shell Configuration**: Uses `lineinfile` and `copy` modules
  - Bash: Only adds PATH if not present
  - Fish: Overwrites config file (declarative, always correct state)

- **Toolchain Updates**: Uses `changed_when` to detect actual updates
  - Only reports change if "updated" or "installed" in output

## Post-Installation

After installation:

### Start Using Rust

```bash
# Restart shell or source profile
source ~/.bashrc  # For Bash
# Or start new Fish shell

# Verify installation
rustc --version
cargo --version
rustup --version

# Create first project
cargo new hello-world
cd hello-world
cargo run
```

### Update Everything with Topgrade

```bash
# Update system, Rust, cargo tools, and more
topgrade

# Dry run (see what would update)
topgrade -n

# Skip confirmations
topgrade -y
```

### Update Cargo Tools

```bash
# List installed cargo binaries
cargo install-update -l

# Update all cargo binaries
cargo install-update -a

# Update specific tool
cargo install-update ripgrep
```

### Manage Rust Toolchains

```bash
# Update Rust
rustup update

# Show installed toolchains
rustup show

# Install nightly
rustup toolchain install nightly

# Switch default toolchain
rustup default nightly

# Add components
rustup component add rustfmt clippy
```

## Tags

Available tags for selective execution:

- `rust`: All Rust-related tasks
- `rustup`: Rustup installation tasks
- `cargo`: Cargo-related tasks
- `packages`: System package installation
- `dependencies`: Dependency installation
- `shell`: Shell integration (Bash/Fish)
- `bash`: Bash-specific tasks
- `fish`: Fish-specific tasks
- `tools`: Cargo tools installation (topgrade, cargo-update)
- `topgrade`: Topgrade installation only
- `cargo-update`: cargo-update installation only
- `update`: Rust toolchain update
- `cleanup`: Cleanup tasks

## Testing

### Syntax Check
```bash
ansible-playbook workstation.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook workstation.yml --check --diff --tags rust -K
```

### Full Installation
```bash
ansible-playbook workstation.yml --tags rust -K
```

### Idempotency Test
```bash
# Run twice - second run should show minimal/no changes
ansible-playbook workstation.yml --tags rust -K
ansible-playbook workstation.yml --tags rust -K
```

### Test Rust Installation
```bash
# As the user (not root)
rustc --version
cargo --version
rustup --version
topgrade --version
cargo install-update --version

# Test building
cargo new test-project
cd test-project
cargo build
cargo run
```

## Troubleshooting

### Rust not in PATH

If Rust commands aren't found after installation:

```bash
# For Bash
source ~/.bashrc

# For Fish
# Start a new Fish shell or
source ~/.config/fish/conf.d/rust.fish

# Or add manually to current session
export PATH="$HOME/.cargo/bin:$PATH"
```

### Cargo install fails

If cargo install fails with network errors:

```bash
# Try with more verbose output
cargo install -v topgrade

# Check network connectivity
curl -I https://crates.io

# Update cargo registry
cargo search --limit 0
```

### Permission denied

Rust installation should NOT require sudo for normal use:

```bash
# Correct: Run as regular user
cargo install ripgrep

# Incorrect: Don't use sudo
sudo cargo install ripgrep  # DON'T DO THIS
```

### Update issues

If rustup update fails:

```bash
# Manually update rustup
rustup self update

# Then update toolchains
rustup update
```

### Complete removal and reinstall

```bash
# Remove Rust
rustup self uninstall

# Remove Cargo packages
rm -rf ~/.cargo ~/.rustup

# Re-run Ansible role
ansible-playbook workstation.yml --tags rust -K
```

## Advanced Usage

### Installing Specific Rust Version

```yaml
- role: rust
  vars:
    rust_toolchain: "1.70.0"  # Specific version
```

### Multiple Toolchains

```yaml
- role: rust
  vars:
    rust_toolchain: stable
    rust_additional_tools:
      - cargo-edit  # Adds cargo add/rm/upgrade commands
```

Then manually add nightly:
```bash
rustup toolchain install nightly
rustup default stable  # Keep stable as default
cargo +nightly build   # Use nightly for specific build
```

### Minimal Profile for CI/CD

```yaml
- role: rust
  vars:
    rustup_profile: minimal
    rust_install_topgrade: false
    rust_install_cargo_update: false
    rust_add_to_bashrc: false
    rust_add_to_fish: false
```

### Developer Setup with Popular Tools

```yaml
- role: rust
  vars:
    rust_additional_tools:
      - ripgrep         # Fast grep (rg)
      - bat             # Cat with syntax (bat)
      - fd-find         # Fast find (fd)
      - exa             # Modern ls (exa)
      - starship        # Cross-shell prompt
      - tokei           # Code statistics
      - hyperfine       # Benchmarking
      - cargo-edit      # cargo add/rm/upgrade
      - cargo-watch     # Watch and rebuild
      - cargo-expand    # Expand macros
```

## Topgrade Configuration

After installation, configure topgrade:

```bash
# Create config file
topgrade --edit-config

# Example ~/.config/topgrade.toml
[misc]
assume_yes = false
cleanup = true
no_retry = false

# Disable specific steps
[disable]
apt = false
snap = true  # Disable snap if you don't use it
flatpak = false
```

## Security Considerations

- Rust is installed per-user (not system-wide)
- Installation uses official rustup.rs installer
- Cargo packages are downloaded from crates.io (official registry)
- No sudo required for normal Rust usage
- Build dependencies installed via APT (official Ubuntu packages)

## Performance Tips

- Use `rustup_profile: minimal` for faster installation
- Skip tools you don't need
- Use `--release` flag for optimized builds: `cargo build --release`
- Parallel compilation is enabled by default

## Integration with Other Roles

This role works well with:
- `fish_shell`: Automatic Fish integration if Fish is installed
- `vscode`: Rust extension for VS Code
- Any development environment role

## License

MIT

## Author Information

Created as part of the kubuntu-workstation automation project.

## Changelog

### Version 1.0 (Current)
- Initial implementation
- Rustup installation with configurable toolchain
- Topgrade and cargo-update installation
- Bash and Fish shell integration
- Idempotent design
- Comprehensive documentation
- Support for additional cargo tools

## References

- [Official Rust Website](https://www.rust-lang.org/)
- [Rustup Documentation](https://rust-lang.github.io/rustup/)
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [The Rust Programming Language Book](https://doc.rust-lang.org/book/)
- [Topgrade GitHub](https://github.com/topgrade-rs/topgrade)
- [cargo-update GitHub](https://github.com/nabijaczleweli/cargo-update)
