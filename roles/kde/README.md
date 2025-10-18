# KDE Applications Ansible Role

Idempotent Ansible role to install a curated collection of KDE and related applications on Kubuntu/Ubuntu systems.

## Features

- ✅ **Fully Idempotent**: Safe to run multiple times
- ✅ **Comprehensive**: 15 essential KDE applications
- ✅ **Well-Organized**: Applications categorized by purpose
- ✅ **Informative**: Detailed post-installation guide
- ✅ **Configurable**: Easy to customize application list
- ✅ **Integrated**: All apps work seamlessly with KDE Plasma

## Requirements

- Kubuntu/Ubuntu 24.04 (or compatible)
- Ansible 2.9 or higher
- Root/sudo access
- KDE Plasma desktop environment (recommended)

## Installed Applications

### Multimedia (2)
- **VLC** - Universal media player
- **Kamoso** - Webcam recorder and photo booth

### Documents (1)
- **Okular** - Universal document viewer (PDF, ePub, etc.)

### Graphics (1)
- **GIMP** - GNU Image Manipulation Program

### Development (3)
- **Meld** - Visual diff and merge tool
- **Okteta** - Hex/binary editor
- **Kommit** - Git client for KDE

### Utilities (3)
- **Spectacle** - Screenshot capture utility
- **Yakuake** - Drop-down terminal emulator
- **Filelight** - Disk usage visualizer

### Security (2)
- **KGpg** - GPG encryption interface
- **Kleopatra** - Certificate manager and crypto GUI

### File Management (1)
- **Krusader** - Advanced twin-panel file manager

### Productivity (2)
- **Zanshin** - To-do and task management
- **Akregator** - RSS/Atom feed reader

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# KDE applications to install (full list with descriptions)
kde_applications:
  - name: vlc
    description: "VLC media player - plays most multimedia files"
    category: multimedia
  # ... (see defaults/main.yml for complete list)

# Package state: present, latest, absent
kde_package_state: present

# Update APT cache before installation
kde_update_cache: yes

# Install recommended packages
kde_install_recommends: yes
```

## Dependencies

None. All applications are available in standard Ubuntu repositories.

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  become: true
  roles:
    - kde
```

### Custom Configuration

```yaml
- hosts: localhost
  become: true
  roles:
    - role: kde
      vars:
        kde_package_state: latest  # Always get latest versions
```

### Selective Installation with Tags

```yaml
# Install only multimedia applications
ansible-playbook playbook.yml --tags kde,multimedia

# Install only development tools
ansible-playbook playbook.yml --tags kde,development

# Install everything except graphics
ansible-playbook playbook.yml --tags kde --skip-tags graphics
```

## What This Role Does

1. **Updates APT cache** (with 1-hour cache validity)
2. **Checks installed applications** (for informational purposes)
3. **Installs all KDE applications** (via single APT command)
4. **Verifies key installations** (VLC, GIMP, Meld)
5. **Displays comprehensive guide** (usage instructions for all apps)

## Idempotency Guarantees

This role ensures idempotent behavior through:

- **APT Module**: Uses Ansible's native `apt` module
  - Checks package state before installation
  - Only installs missing packages
  - Reports changes accurately

- **Cache Management**: Uses `cache_valid_time: 3600`
  - Prevents unnecessary APT cache updates
  - Only updates if cache older than 1 hour

- **Version Checks**: Verifies installations without making changes
  - Uses `changed_when: false` for verification tasks
  - Safe to run repeatedly

## Post-Installation

After installation, all applications are available:

### Launch Applications

**From Application Launcher:**
- Press Meta/Super key
- Type application name (vlc, gimp, meld, etc.)
- Click to launch

**From Terminal:**
```bash
vlc           # VLC Media Player
gimp          # GIMP
meld          # Meld diff tool
spectacle     # Screenshot tool
yakuake       # Drop-down terminal
filelight     # Disk usage
okular        # Document viewer
krusader      # File manager
kommit        # Git client
kgpg          # GPG interface
kleopatra     # Certificate manager
kamoso        # Webcam app
okteta        # Hex editor
zanshin       # Task manager
akregator     # Feed reader
```

### Quick Start Guide

**VLC Media Player:**
```bash
# Play video
vlc /path/to/video.mp4

# Play from URL
vlc https://example.com/stream.m3u8

# Convert video
vlc input.avi --sout=file/ogg:output.ogg
```

**GIMP:**
```bash
# Launch GIMP
gimp

# Open image
gimp image.png

# Batch processing (use GIMP filters from command line)
gimp -i -b '(batch-function)' -b '(gimp-quit 0)'
```

**Meld:**
```bash
# Compare 2 files
meld file1.txt file2.txt

# Compare 3 files (merge)
meld file1.txt base.txt file2.txt

# Compare directories
meld dir1/ dir2/

# Git integration
git difftool -t meld
git mergetool -t meld
```

**Spectacle (Screenshots):**
- `Print Screen` - Capture screen
- `Shift+Print Screen` - Capture window
- `Meta+Shift+Print Screen` - Capture region

**Yakuake (Drop-down Terminal):**
- `F12` - Toggle terminal (default)
- Starts automatically in background
- Always available

**Krusader (File Manager):**
- `Tab` - Switch panels
- `F3` - View file
- `F4` - Edit file
- `F5` - Copy
- `F6` - Move
- `F7` - Create directory
- `F8` - Delete

## Application Categories

### For Media Playback
- **VLC**: All video/audio formats, streaming
- **Kamoso**: Webcam photos and videos

### For Document Reading
- **Okular**: PDF, ePub, with annotation support

### For Image Editing
- **GIMP**: Professional photo editing and manipulation

### For Development
- **Meld**: File/directory comparison, Git integration
- **Okteta**: Binary/hex file editing
- **Kommit**: Visual Git client

### For Screenshots
- **Spectacle**: Screen, window, region capture

### For File Management
- **Krusader**: Twin-panel file manager with advanced features
- **Filelight**: Visual disk usage analysis

### For Security
- **KGpg**: GPG key management and file encryption
- **Kleopatra**: Certificate management, S/MIME, OpenPGP

### For Productivity
- **Zanshin**: GTD-style task management
- **Akregator**: RSS feed reader

### For Quick Access
- **Yakuake**: Always-available drop-down terminal

## Tags

Available tags for selective execution:

**By Purpose:**
- `kde`: All KDE applications
- `multimedia`: VLC, Kamoso
- `documents`: Okular
- `graphics`: GIMP
- `development`: Meld, Okteta, Kommit
- `utilities`: Spectacle, Yakuake, Filelight
- `security`: KGpg, Kleopatra
- `filemanagement`: Krusader
- `productivity`: Zanshin, Akregator

**By Application:**
- `vlc`, `okular`, `gimp`, `meld`, `spectacle`, `yakuake`, `kamoso`, `filelight`, `kgpg`, `kleopatra`, `krusader`, `okteta`, `kommit`, `zanshin`, `akregator`

**By Task:**
- `packages`: Package installation tasks

## Testing

### Syntax Check
```bash
ansible-playbook workstation.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook workstation.yml --check --diff --tags kde -K
```

### Full Installation
```bash
ansible-playbook workstation.yml --tags kde -K
```

### Idempotency Test
```bash
# Run twice - second run should show no changes
ansible-playbook workstation.yml --tags kde -K
ansible-playbook workstation.yml --tags kde -K
```

### Verify Installation
```bash
# Check all applications are installed
dpkg -l | grep -E "vlc|okular|gimp|meld|spectacle|yakuake|kamoso|filelight|kgpg|kleopatra|krusader|okteta|kommit|zanshin|akregator"

# Test launching applications
vlc --version
gimp --version
meld --version
spectacle --version
```

## Customization

### Add More Applications

Edit `defaults/main.yml`:

```yaml
kde_applications:
  # ... existing apps ...
  - name: kdenlive
    description: "Video editor"
    category: multimedia
  - name: krita
    description: "Digital painting"
    category: graphics
```

### Remove Applications

Remove entries from the `kde_applications` list in `defaults/main.yml`.

### Install Specific Category

Use tags:
```bash
# Only multimedia
ansible-playbook workstation.yml --tags multimedia -K

# Development tools only
ansible-playbook workstation.yml --tags development -K
```

## Troubleshooting

### Application not found after installation

```bash
# Update application cache
kbuildsycoca5 --noincremental

# Or refresh Plasma
killall plasmashell && kstart5 plasmashell
```

### Missing application in launcher

```bash
# Rebuild desktop database
update-desktop-database ~/.local/share/applications/
```

### Yakuake not starting automatically

```bash
# Add to autostart
cp /usr/share/applications/org.kde.yakuake.desktop ~/.config/autostart/

# Or via System Settings
# System Settings → Startup and Shutdown → Autostart → Add Application → Yakuake
```

### Spectacle shortcuts not working

```bash
# Configure in System Settings
# System Settings → Shortcuts → Spectacle
# Or right-click desktop → Configure Desktop → Shortcuts
```

## Integration Tips

### Set Default Applications

**System Settings → Applications → Default Applications:**
- Document viewer: Okular
- File manager: Krusader (or Dolphin)
- Terminal: Yakuake (or Konsole)
- Image viewer: Gwenview (or use GIMP for editing)

### Keyboard Shortcuts

**Add custom shortcuts in System Settings:**
- `Meta+V` → VLC
- `Meta+G` → GIMP
- `Meta+M` → Meld
- `F12` → Yakuake (default)

### File Associations

**Associate file types:**
- Right-click file → Open With → Choose Application
- Or: System Settings → Applications → File Associations

### Context Menu Integration

Many apps add right-click menu items:
- Spectacle: Screenshot options
- KGpg: Encrypt/Sign file
- Meld: Compare with...
- Krusader: Advanced operations

## Performance Tips

- **VLC**: Use hardware acceleration (Tools → Preferences → Input/Codecs)
- **GIMP**: Adjust tile cache (Edit → Preferences → Environment)
- **Yakuake**: Limit scrollback to reduce memory usage
- **Krusader**: Disable thumbnails for faster browsing

## Security Considerations

- **KGpg/Kleopatra**: Manage encryption keys securely
- **VLC**: Be cautious with untrusted media files
- **All apps**: Receive security updates via APT

## Recommended Workflows

### Screenshot Workflow
1. Press `Print Screen` (or `Shift+Print Screen` for window)
2. Spectacle opens with preview
3. Annotate if needed
4. Save or copy to clipboard

### File Comparison Workflow
1. Open Meld
2. Drag two files/directories to compare
3. Edit directly in Meld
4. Save changes

### File Management Workflow
1. Launch Krusader
2. Navigate directories in twin panels
3. Use F5/F6 for copy/move
4. Archive handling with right-click

### Task Management Workflow
1. Launch Zanshin
2. Add tasks with `Insert` key
3. Organize into projects
4. Set contexts and priorities

## Additional Resources

**VLC:**
- Official docs: https://www.videolan.org/doc/
- Keyboard shortcuts: https://wiki.videolan.org/Hotkeys_table/

**GIMP:**
- Official docs: https://docs.gimp.org/
- Tutorials: https://www.gimp.org/tutorials/

**Meld:**
- Documentation: https://meldmerge.org/
- Git integration: https://meldmerge.org/help/git-integration.html

**KDE Apps:**
- KDE UserBase: https://userbase.kde.org/
- KDE Documentation: https://docs.kde.org/

## Comparison with Alternatives

| Purpose | This Role Installs | Alternative |
|---------|-------------------|-------------|
| Media Player | VLC | MPV, Celluloid |
| Document Viewer | Okular | Evince, PDF Reader |
| Image Editor | GIMP | Krita, Photopea |
| Diff Tool | Meld | KDiff3, Beyond Compare |
| File Manager | Krusader | Dolphin (default), Midnight Commander |
| Terminal | Yakuake | Konsole, Guake, Tilda |
| Screenshot | Spectacle | Flameshot, Shutter |

## License

MIT

## Author Information

Created as part of the kubuntu-workstation automation project.

## Changelog

### Version 1.0 (Current)
- Initial implementation
- 15 KDE and related applications
- Organized by category
- Idempotent installation
- Comprehensive documentation
- Tag-based selective installation
