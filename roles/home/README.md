# Home Directory Setup Ansible Role

Idempotent Ansible role to configure a custom home directory structure with lowercase directory names and organized media folders, replacing Ubuntu's default XDG directories.

## Features

- ✅ **Fully Idempotent**: Safe to run multiple times
- ✅ **Custom Structure**: Lowercase directory names for easier CLI usage
- ✅ **Media Organization**: All media files organized under `~/media`
- ✅ **XDG Compliant**: Applications automatically use new directory structure
- ✅ **Clean Migration**: Removes default uppercase directories
- ✅ **Developer-Friendly**: Includes `~/bin`, `~/projects`, `~/workspace`

## Requirements

- Kubuntu/Ubuntu 24.04 (or compatible)
- Ansible 2.9 or higher
- User account defined in `vars.yml` (`username` variable)
- **IMPORTANT**: This role runs as the user (NOT as root)

## Directory Structure

### Created Directories

```
~/
├── bin/              Personal scripts and executables (add to PATH)
├── archive/          Long-term storage and archives
├── applications/     Application-specific data
├── desktop/          Desktop files (replaces ~/Desktop)
├── downloads/        Downloads (replaces ~/Downloads)
├── documents/        Documents (replaces ~/Documents)
├── projects/         Development projects
├── notes/            Personal notes and documentation
├── media/
│   ├── music/        Music files (replaces ~/Music)
│   ├── pictures/     Images and photos (replaces ~/Pictures)
│   ├── templates/    Templates (replaces ~/Templates)
│   └── videos/       Video files (replaces ~/Videos)
├── workspace/        Active working area
└── tmp/              Temporary files
```

### XDG Directory Mappings

| Old (Default)  | New (Custom)        | XDG Variable           |
|----------------|---------------------|------------------------|
| `~/Desktop`    | `~/desktop`         | `XDG_DESKTOP_DIR`      |
| `~/Documents`  | `~/documents`       | `XDG_DOCUMENTS_DIR`    |
| `~/Downloads`  | `~/downloads`       | `XDG_DOWNLOAD_DIR`     |
| `~/Music`      | `~/media/music`     | `XDG_MUSIC_DIR`        |
| `~/Pictures`   | `~/media/pictures`  | `XDG_PICTURES_DIR`     |
| `~/Templates`  | `~/media/templates` | `XDG_TEMPLATES_DIR`    |
| `~/Videos`     | `~/media/videos`    | `XDG_VIDEOS_DIR`       |
| `~/Public`     | *removed*           | `XDG_PUBLICSHARE_DIR`  |

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# User configuration (from vars.yml)
home_username: "{{ username }}"
home_user_home: "{{ user_home }}"

# Custom directories to create
home_custom_directories:
  - bin
  - archive
  - applications
  - desktop
  - downloads
  - documents
  - projects
  - notes
  - media/music
  - media/pictures
  - media/templates
  - media/videos
  - workspace
  - tmp

# Default XDG directories to remove
home_remove_default_dirs:
  - Desktop
  - Documents
  - Downloads
  - Music
  - Pictures
  - Public
  - Templates
  - Videos

# Update XDG user directories after configuration
home_update_xdg: true
```

## Dependencies

None.

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  become: true  # Role tasks run as user, not root
  roles:
    - home
```

### Custom Directories

```yaml
- hosts: localhost
  become: true
  roles:
    - role: home
      vars:
        home_custom_directories:
          - bin
          - desktop
          - downloads
          - documents
          - projects
          - media/music
          - media/pictures
          - media/videos
          # Add your own
          - clients
          - personal
```

### Keep Some Default Directories

```yaml
- hosts: localhost
  become: true
  roles:
    - role: home
      vars:
        home_remove_default_dirs:
          - Desktop  # Only remove Desktop
          # Keep Documents, Downloads, etc.
```

## What This Role Does

1. **Ensures ~/.config exists** (required for XDG configuration)
2. **Creates XDG configuration file** (`~/.config/user-dirs.dirs`)
3. **Creates custom directories** (bin, archive, projects, media/*, etc.)
4. **Checks for default directories** (Desktop, Documents, etc.)
5. **Removes default directories** (only if they exist)
6. **Updates XDG user directories** (runs `xdg-user-dirs-update`)
7. **Displays helpful information** (directory structure and mappings)

## Idempotency Guarantees

This role ensures idempotent behavior through:

- **File Module**: Creates directories only if they don't exist
  - Uses `state: directory` (idempotent)
  - Sets owner/group/permissions consistently

- **Stat Module**: Checks directory existence before removal
  - Only removes if directory exists
  - Uses `when: item.stat.exists` condition

- **Template Module**: Only updates if content changed
  - Compares existing file content
  - Reports change accurately

- **XDG Update**: Safe to run repeatedly
  - Uses `changed_when: false` (informational only)

## Post-Installation

After running this role:

### Applications Automatically Use New Paths

Most applications respect XDG directories and will automatically:
- Save downloads to `~/downloads`
- Open file dialogs in `~/documents`
- Save screenshots to `~/desktop`
- Store music in `~/media/music`
- Store pictures in `~/media/pictures`

### File Manager Integration

**Dolphin (KDE), Nautilus (GNOME), Thunar (XFCE):**
- Bookmarks automatically updated
- Side panel shows new directory names
- Quick access links point to new locations

### Desktop Integration

**KDE Plasma:**
- Desktop folder: `~/desktop`
- Widgets and desktop files appear in lowercase folder

**Other Desktop Environments:**
- Desktop icons appear in `~/desktop`
- System follows XDG configuration

### Add ~/bin to PATH

The `~/bin` directory is perfect for personal scripts:

```bash
# Add to ~/.bashrc or ~/.profile
export PATH="$HOME/bin:$PATH"

# Or in Fish (~/.config/fish/config.fish)
set -gx PATH $HOME/bin $PATH
```

Then:
```bash
# Create a script
echo '#!/bin/bash\necho "Hello!"' > ~/bin/hello
chmod +x ~/bin/hello

# Run it from anywhere
hello
```

### Directory Usage Examples

```bash
# Development projects
cd ~/projects
git clone https://github.com/user/repo

# Active workspace
cd ~/workspace
# Work on current tasks

# Archive old projects
mv ~/projects/old-project ~/archive/

# Personal scripts
echo '#!/bin/bash\ndate' > ~/bin/today
chmod +x ~/bin/today

# Notes and documentation
vim ~/notes/README.md

# Media organization
cd ~/media/music
cd ~/media/pictures
cd ~/media/videos
```

## Benefits

### Lowercase Directory Names
- ✅ Easier to type in terminal
- ✅ No need for quotes or escaping
- ✅ Consistent with Unix conventions

**Before:**
```bash
cd ~/Documents  # Need capital D
cd ~/Downloads  # Need capital D
```

**After:**
```bash
cd ~/documents  # lowercase, easier
cd ~/downloads  # lowercase, easier
```

### Organized Media
- ✅ All media files under `~/media`
- ✅ Clear separation from documents
- ✅ Easy to backup specific categories

### Developer-Friendly
- ✅ `~/bin` for personal scripts
- ✅ `~/projects` for development
- ✅ `~/workspace` for active work
- ✅ `~/archive` for old files

### XDG Compliance
- ✅ Applications automatically work
- ✅ No manual configuration needed
- ✅ Standard across desktop environments

## Migration from Default Directories

### Before Running This Role

If you have existing files in default directories:

```bash
# Backup important files first
tar czf ~/backup-home-$(date +%Y%m%d).tar.gz \
  ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos

# Or move files manually
mv ~/Desktop/* ~/desktop/
mv ~/Documents/* ~/documents/
mv ~/Downloads/* ~/downloads/
mv ~/Music/* ~/media/music/
mv ~/Pictures/* ~/media/pictures/
mv ~/Videos/* ~/media/videos/
```

### After Running This Role

The role removes empty default directories. If they contain files:

1. Files will prevent directory removal (Ansible will skip)
2. Manually move files to new locations
3. Run role again to remove empty directories

## Tags

Available tags for selective execution:

- `home`: All home directory tasks
- `xdg`: XDG configuration tasks
- `configuration`: Configuration file creation
- `directories`: Directory creation
- `cleanup`: Default directory removal

## Testing

### Syntax Check
```bash
ansible-playbook workstation.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook workstation.yml --check --diff --tags home -K
```

### Full Installation
```bash
ansible-playbook workstation.yml --tags home -K
```

### Idempotency Test
```bash
# Run twice - second run should show minimal changes
ansible-playbook workstation.yml --tags home -K
ansible-playbook workstation.yml --tags home -K
```

### Verify Setup
```bash
# Check directories exist
ls -la ~/ | grep -E "bin|archive|projects|media|workspace"

# Check XDG configuration
cat ~/.config/user-dirs.dirs

# Test XDG directories
xdg-user-dir DESKTOP
xdg-user-dir DOCUMENTS
xdg-user-dir DOWNLOAD
```

## Troubleshooting

### Directories not removed

**Cause**: Directories contain files

**Solution**:
```bash
# Check what's in directories
ls -la ~/Desktop ~/Documents ~/Downloads

# Move files to new locations
mv ~/Desktop/* ~/desktop/
mv ~/Documents/* ~/documents/

# Re-run role
ansible-playbook workstation.yml --tags home,cleanup -K
```

### Applications still use old directories

**Cause**: XDG cache not updated

**Solution**:
```bash
# Update XDG directories manually
xdg-user-dirs-update

# Restart file manager
killall dolphin  # KDE
killall nautilus # GNOME

# Or logout and login again
```

### Desktop files disappeared

**Cause**: Desktop using `~/Desktop` (old) instead of `~/desktop` (new)

**Solution**:
```bash
# Check XDG desktop directory
xdg-user-dir DESKTOP
# Should return: /home/username/desktop

# Move files if they're in wrong location
mv ~/Desktop/* ~/desktop/

# Restart desktop
killall plasmashell && kstart5 plasmashell  # KDE
```

### ~/bin not in PATH

**Cause**: Need to add to shell configuration

**Solution**:
```bash
# For Bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For Fish
echo 'set -gx PATH $HOME/bin $PATH' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

## Customization

### Add More Directories

Edit `defaults/main.yml` or override in playbook:

```yaml
home_custom_directories:
  - bin
  - projects
  # ... existing ...
  - clients         # Client work
  - personal        # Personal projects
  - sandbox         # Experimentation
  - backups         # Local backups
```

### Keep Some Default Directories

```yaml
home_remove_default_dirs:
  - Desktop    # Remove this
  - Public     # Remove this
  # Keep Documents, Downloads, etc. by not listing them
```

### Change Media Structure

```yaml
home_custom_directories:
  - music       # Flat structure
  - pictures
  - videos
  # Instead of media/music, media/pictures, etc.
```

Then update `templates/user-dirs.j2`:
```
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_VIDEOS_DIR="$HOME/videos"
```

## Integration with Other Roles

This role works well with:
- `fish_shell`: Fish configuration respects XDG directories
- `git`: Git repositories in `~/projects`
- `rust`: Cargo projects in `~/projects`
- Any development tools

## Performance Tips

- Run at the end of playbook (after other roles)
- Manually move large files before running
- Use `~/archive` for old/infrequently accessed files

## Security Considerations

- All directories created with `0755` permissions
- Owner/group set correctly
- No sudo required (runs as user)
- XDG configuration protects against path traversal

## Common Workflows

### Development Workflow
```bash
cd ~/projects          # Long-term projects
cd ~/workspace         # Current work
~/bin/my-script        # Personal tools
```

### Organization Workflow
```bash
~/documents            # Current documents
~/archive              # Old files
~/notes                # Personal notes
~/media/pictures       # Photos
```

### Backup Workflow
```bash
# Backup important directories
tar czf backup.tar.gz ~/projects ~/documents ~/notes

# Backup media separately (large)
tar czf media-backup.tar.gz ~/media
```

## Comparison with Defaults

| Aspect | Default Ubuntu | This Role |
|--------|----------------|-----------|
| Directory names | Mixed case | Lowercase |
| Media organization | Scattered in ~ | Under ~/media |
| Developer dirs | None | bin, projects, workspace |
| Archive location | None | ~/archive |
| XDG compliance | Yes | Yes |
| CLI friendly | No (capitals) | Yes (lowercase) |

## License

MIT

## Author Information

Created as part of the kubuntu-workstation automation project.

## Changelog

### Version 2.0 (Current - Fixed)
- Fixed critical syntax errors
- Proper privilege handling (runs as user)
- Added idempotency checks
- Moved template to correct location
- Added comprehensive documentation
- Added defaults file
- Added tags for selective execution

### Version 1.0
- Initial implementation with errors
