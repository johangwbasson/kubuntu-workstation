# kubuntu-workstation

Automated Kubuntu workstation setup using Ansible. This project provides a secure, reproducible configuration for a complete development and productivity workstation.

## Overview

This repository uses Ansible to automate the installation and configuration of a modern Kubuntu workstation with:

- **Development Tools**: Docker, kubectl, Terraform, AWS CLI, Azure CLI, Google Cloud CLI
- **Programming Languages**: Java, Rust
- **Editors & IDEs**: VSCode, Sublime Text, Neovim with LazyVim
- **Browsers**: Firefox, Brave, Chromium, Chrome
- **Productivity Apps**: OnlyOffice, Obsidian, MEGAsync
- **Communication**: Slack, Zoom
- **Security**: ClamAV antivirus, UFW firewall, 1Password, Bitwarden
- **Developer Utilities**: LazyDocker, LazyGit, Git, Fish shell
- **System Optimization**: BTRFS optimizations, kernel module blacklist, font configuration

## Prerequisites

- A fresh or existing Kubuntu installation
- `sudo` privileges
- Ansible installed on the target machine

### Installing Ansible

```bash
sudo apt update
sudo apt install -y ansible
```

## Quick Start

1. Clone this repository:

```bash
git clone https://github.com/johangwbasson/kubuntu-workstation.git
cd kubuntu-workstation
```

2. Create your variables files:

```bash
# Copy and edit the example variables file
cp vars.yml.example vars.yml
cp .vars.yml.example .vars.yml

# Edit with your preferences
nano vars.yml
nano .vars.yml
```

3. Run the playbook:

```bash
ansible-playbook workstation.yml
```

## Configuration

The playbook expects two variable files:

- `vars.yml` - User-specific configuration (can be checked into git)
- `.vars.yml` - Sensitive configuration (should be gitignored)

These files should define any variables required by the roles you're using.

## Selective Installation

You can run specific roles using Ansible tags:

```bash
# Install only Docker
ansible-playbook workstation.yml --tags docker

# Install development tools
ansible-playbook workstation.yml --tags cli_tools,docker,kubectl,terraform

# Skip certain roles
ansible-playbook workstation.yml --skip-tags snap,kde
```

## Testing Changes

Before applying changes to your system:

1. **Lint the playbook**:
```bash
ansible-lint workstation.yml
```

2. **Dry run (check mode)**:
```bash
ansible-playbook workstation.yml --check --diff
```

3. **Run specific role in check mode**:
```bash
ansible-playbook workstation.yml --check --diff --tags <role_name>
```

## Project Structure

```
.
├── workstation.yml          # Main playbook
├── vars.yml                 # User configuration
├── .vars.yml                # Sensitive configuration (gitignored)
├── roles/                   # Ansible roles
│   ├── awscli/
│   ├── azure_cli/
│   ├── bitwarden/
│   ├── brave/
│   ├── btrfs_optimize/
│   ├── chrome-browser/
│   ├── chromium/
│   ├── clamav/
│   ├── cli_tools/
│   ├── docker/
│   ├── firefox/
│   ├── fish_shell/
│   ├── flatpak/
│   ├── fonts/
│   ├── gcloud_cli/
│   ├── git/
│   ├── home/
│   ├── insomnia/
│   ├── java/
│   ├── kde/
│   ├── kernel_module_blacklist/
│   ├── kubectl/
│   ├── lazydocker/
│   ├── lazygit/
│   ├── lazyvim/
│   ├── megasync/
│   ├── neovim/
│   ├── networking/
│   ├── obsidian/
│   ├── onepassword/
│   ├── onlyoffice/
│   ├── postman/
│   ├── remove_snap/
│   ├── rust/
│   ├── slack/
│   ├── spotify/
│   ├── sublime_text/
│   ├── terraform/
│   ├── ubuntu_drivers/
│   ├── ufw/
│   └── vscode/
└── README.md
```

## Security Principles

This project follows security best practices:

- **Verified Sources**: Only uses official repositories, trusted PPAs, and verified downloads
- **Checksum Verification**: Downloads are verified using SHA256 checksums where possible
- **Minimal Privileges**: Follows the principle of least privilege
- **No Insecure Patterns**: Avoids patterns like `curl | bash`
- **Firewall by Default**: Includes UFW firewall configuration
- **Antivirus**: Includes ClamAV setup

## Customization

### Adding a New Role

1. Create the role structure:
```bash
mkdir -p roles/my_tool/{tasks,defaults,vars}
```

2. Create `roles/my_tool/tasks/main.yml` with your tasks

3. Add the role to `workstation.yml`

4. Test with `ansible-playbook workstation.yml --check --tags my_tool`

### Modifying Existing Roles

Each role is independent and can be customized by editing the files in `roles/<role_name>/`:

- `tasks/main.yml` - The tasks to execute
- `defaults/main.yml` - Default variables (lowest precedence)
- `vars/main.yml` - Role variables (higher precedence)

## Troubleshooting

### Playbook Fails on First Run

Some roles may have dependencies. Run the playbook again or install dependencies manually.

### Permission Errors

Ensure you're running with `sudo` privileges and that your user is in the `sudo` group.

### Package Not Found

Some repositories may need to be refreshed:
```bash
sudo apt update
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes with `ansible-lint` and `--check` mode
4. Submit a pull request

## License

This project is provided as-is for personal and educational use.

## Acknowledgments

This repository was inspired by and includes elements from [brabster/xubuntu-workstation](https://github.com/brabster/xubuntu-workstation/tree/main).

