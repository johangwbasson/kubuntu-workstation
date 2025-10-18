# MEGAsync Ansible Role

Idempotent Ansible role to install and configure MEGAsync (MEGA cloud storage sync client) on Ubuntu/Kubuntu systems.

## Features

- ✅ **Fully Idempotent**: Safe to run multiple times
- ✅ **Self-Healing**: Automatically detects and fixes corrupted GPG keyrings
- ✅ **Conflict Prevention**: Removes conflicting repository files before installation
- ✅ **Version Aware**: Automatically detects Ubuntu version (24.04, etc.)
- ✅ **Optional Components**: MEGAcmd CLI tools (configurable)
- ✅ **Modern APT Security**: Uses `signed-by` for repository GPG keys

## Requirements

- Ubuntu/Kubuntu 24.04 (automatically detected)
- Ansible 2.9 or higher
- Root/sudo access

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# MEGA GPG key URL (automatically uses correct Ubuntu version)
mega_gpg_key_url: https://mega.nz/linux/repo/xUbuntu_{{ ansible_distribution_version }}/Release.key

# Path to store GPG keyring
mega_gpg_keyring_path: /usr/share/keyrings/megasync-archive-keyring.gpg

# MEGA repository URL (automatically uses correct Ubuntu version)
mega_repo_url: https://mega.nz/linux/repo/xUbuntu_{{ ansible_distribution_version }}

# Package state: present, latest, absent
mega_package_state: present

# Install MEGAcmd CLI tools (true/false)
mega_install_megacmd: true
```

## Dependencies

None.

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  become: true
  roles:
    - megasync
```

### Custom Configuration

```yaml
- hosts: localhost
  become: true
  roles:
    - role: megasync
      vars:
        mega_install_megacmd: false  # Don't install CLI tools
        mega_package_state: latest   # Always get latest version
```

### With Tags

```yaml
# Install only MEGAsync
ansible-playbook playbook.yml --tags megasync

# Install without CLI tools
ansible-playbook playbook.yml --tags megasync --skip-tags cli
```

## What This Role Does

1. **Installs dependencies** (curl, gpg)
2. **Removes conflicting repository files** (megasync.sources, mega.list, etc.)
3. **Validates GPG keyring** (checks for corruption)
4. **Removes corrupted keyrings** (if validation fails)
5. **Downloads and installs MEGA GPG key** (with proper conversion)
6. **Sets correct permissions** (0644, root:root)
7. **Adds MEGA repository** (with modern signed-by syntax)
8. **Installs MEGAsync** (desktop sync client)
9. **Installs MEGAcmd** (optional CLI tools, if enabled)
10. **Displays helpful information** (getting started, commands, tips)

## Idempotency Guarantees

This role ensures idempotent behavior through:

- **GPG Keyring Validation**: Checks if keyring is valid before attempting download
  - Uses `gpg --list-keys --keyring` to validate
  - Removes corrupted keyrings automatically
  - Only downloads if keyring doesn't exist or was removed

- **Repository Cleanup**: Removes conflicting files before creating managed configuration
  - Prevents DEB822 format conflicts
  - Ensures only Ansible-managed repository exists

- **Conditional Installation**: Checks package state before making changes
  - MEGAcmd installation respects `mega_install_megacmd` variable
  - Uses APT's native idempotency for package installation

## Self-Healing Features

If GPG keyrings become corrupted (common issue with manual installations):

1. Role detects corruption via `gpg --list-keys` return code
2. Removes corrupted keyring file
3. Downloads fresh keyring from official source
4. Continues installation normally

## Tags

Available tags for selective execution:

- `megasync`: All MEGAsync tasks
- `packages`: Package installation tasks
- `cloud-storage`: Cloud storage related tasks
- `dependencies`: Dependency installation
- `security`: GPG key and security tasks
- `cleanup`: Cleanup and removal tasks
- `cli`: CLI tools (MEGAcmd) installation

## Testing

### Syntax Check
```bash
ansible-playbook playbook.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook playbook.yml --check --diff --tags megasync
```

### Full Installation
```bash
ansible-playbook playbook.yml --tags megasync -K
```

### Idempotency Test
```bash
# Run twice - second run should show minimal/no changes
ansible-playbook playbook.yml --tags megasync -K
ansible-playbook playbook.yml --tags megasync -K
```

## Post-Installation

After installation:

1. Launch MEGAsync from application menu
2. Log in with MEGA account (or create at https://mega.io)
3. Configure sync folders
4. Enable automatic startup (optional)

If MEGAcmd was installed:
```bash
# Login
mega-login your@email.com

# List files
mega-ls

# Upload file
mega-put /path/to/file /remote/folder

# Download file
mega-get /remote/file /local/folder
```

## Troubleshooting

### GPG Key Issues
If you encounter GPG key errors:
```bash
# Remove corrupted keyring
sudo rm /usr/share/keyrings/megasync-archive-keyring.gpg

# Re-run role
ansible-playbook playbook.yml --tags megasync -K
```

### Repository Conflicts
If you see "Conflicting values set for option Signed-By":
```bash
# Remove all MEGA repository files
sudo rm /etc/apt/sources.list.d/mega*
sudo rm /etc/apt/sources.list.d/megasync*

# Re-run role
ansible-playbook playbook.yml --tags megasync -K
```

### Manual Cleanup
```bash
# Complete removal and reinstall
sudo apt remove --purge megasync megacmd
sudo rm /etc/apt/sources.list.d/megasync.list
sudo rm /usr/share/keyrings/megasync-archive-keyring.gpg
ansible-playbook playbook.yml --tags megasync -K
```

## License

MIT

## Author Information

Created as part of the kubuntu-workstation automation project.

## Changelog

### Version 2.0 (Current)
- Added GPG keyring validation and self-healing
- Added cleanup of conflicting repository files
- Made Ubuntu version detection automatic
- Added `mega_install_megacmd` variable for optional CLI tools
- Enhanced idempotency guarantees
- Added comprehensive documentation

### Version 1.0
- Initial implementation
- Basic MEGAsync installation
