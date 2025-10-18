# BTRFS Optimize Role

Optimizes BTRFS mount options in `/etc/fstab` for SSD storage devices.

## Description

This role modifies `/etc/fstab` to apply SSD-optimized mount options for BTRFS filesystems. It focuses on reducing unnecessary writes, improving performance, and extending SSD lifespan while maintaining data integrity.

## Optimizations Applied

The role replaces current BTRFS mount options with the following optimized set:

| Option | Purpose | Benefit |
|--------|---------|---------|
| `ssd` | Enables SSD-specific optimizations | Better allocation patterns for SSD |
| `noatime` | Prevents access time updates | Significantly reduces write operations |
| `compress=zstd:1` | Zstandard compression level 1 | Reduces storage usage and writes, faster than higher levels |
| `space_cache=v2` | Modern free space cache | Improved performance over v1, faster mounts |
| `discard=async` | Asynchronous TRIM operations | Better SSD longevity with minimal performance impact |
| `commit=120` | Commit interval of 120 seconds | Reduces write frequency (default is 30s) |

### Removed Options

- `autodefrag` - **NOT recommended for SSD**, causes excessive fragmentation detection and writes

## Features

- **Safe fstab modification**: Uses `lineinfile` with backrefs for precise replacements
- **Automatic backup**: Creates timestamped backup before any changes
- **Validation**: Verifies fstab syntax using `findmnt --verify`
- **Idempotent**: Can be run multiple times safely
- **Informative**: Provides detailed before/after information
- **Non-intrusive**: Does not auto-reboot or auto-remount (user control)

## Variables

Default variables in `defaults/main.yml`:

```yaml
# BTRFS mount options optimized for SSD
btrfs_mount_options: "noatime,ssd,compress=zstd:1,space_cache=v2,discard=async,commit=120"

# Backup location for fstab
btrfs_fstab_backup_dir: /root/fstab-backups

# Whether to create a backup before modifying fstab
btrfs_create_backup: true

# Subvolume mount points to optimize
btrfs_subvolumes:
  - mountpoint: "/"
    subvol: "@"
  - mountpoint: "/home"
    subvol: "@home"
```

## Usage

### Add to playbook

Add the role to your `workstation.yml`:

```yaml
roles:
  - btrfs_optimize  # Add near the beginning for filesystem optimization
  - remove_snap
  - ubuntu_drivers
  # ... other roles
```

### Run the role

```bash
# Dry run (check mode) to see what would change
ansible-playbook workstation.yml --tags btrfs_optimize --check --diff

# Apply the changes
ansible-playbook workstation.yml --tags btrfs_optimize

# Or run the entire playbook
ansible-playbook workstation.yml
```

### Verify changes

```bash
# Check the modified fstab
cat /etc/fstab | grep btrfs

# Verify fstab syntax
findmnt --verify --tab-file /etc/fstab

# View backup
ls -lh /root/fstab-backups/
```

### Apply changes

After running the role, you have two options:

#### Option 1: Reboot (Recommended)

```bash
sudo reboot
```

#### Option 2: Remount without reboot (Advanced)

```bash
# Remount root
sudo mount -o remount,noatime,ssd,compress=zstd:1,space_cache=v2,discard=async,commit=120,subvol=@ /

# Remount home
sudo mount -o remount,noatime,ssd,compress=zstd:1,space_cache=v2,discard=async,commit=120,subvol=@home /home

# Verify
mount | grep btrfs
```

## Rollback

If you need to revert the changes:

```bash
# Find the backup
ls -lh /root/fstab-backups/

# Restore the backup (replace timestamp with actual)
sudo cp /root/fstab-backups/fstab.20251018TXXXXXX /etc/fstab

# Verify
findmnt --verify --tab-file /etc/fstab

# Reboot
sudo reboot
```

## Tags

Available tags for selective execution:

- `btrfs` - All BTRFS-related tasks
- `btrfs_optimize` - Optimization tasks
- `filesystem` - Filesystem-related tasks
- `backup` - Backup tasks only
- `root` - Root filesystem tasks
- `home` - Home filesystem tasks
- `verification` - Verification tasks

Example:

```bash
# Run only backup and verification
ansible-playbook workstation.yml --tags backup,verification
```

## Requirements

- **Operating System**: Ubuntu/Kubuntu with BTRFS filesystem
- **Filesystem**: Root and home must be on BTRFS with subvolumes
- **Privileges**: Must run with `become: true` (sudo)
- **Tools**: `findmnt` (usually pre-installed)

## Security Considerations

1. **Backup First**: Always creates a timestamped backup before modifications
2. **Validation**: Validates fstab syntax before committing changes
3. **No Auto-Reboot**: User controls when to reboot
4. **No Auto-Remount**: Prevents accidental filesystem issues
5. **Secure Backup Location**: `/root/fstab-backups` with 0700 permissions
6. **Idempotent**: Safe to run multiple times

## Compatibility

Tested on:
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Kubuntu 24.04 LTS

BTRFS utilities version: 5.16+

## Performance Impact

Expected improvements:
- **Reduced writes**: ~30-50% fewer write operations
- **Better compression**: ~20-40% space savings (varies by data)
- **Faster mounts**: Improved space_cache performance
- **SSD longevity**: Better TRIM management with async discard

## Troubleshooting

### fstab validation fails

```bash
# Check syntax manually
sudo findmnt --verify --tab-file /etc/fstab

# Restore backup if needed
sudo cp /root/fstab-backups/fstab.TIMESTAMP /etc/fstab
```

### Changes not taking effect

Ensure you've rebooted after running the role:

```bash
# Check current mount options
mount | grep btrfs

# Compare with fstab
grep btrfs /etc/fstab
```

### Compression not working

Verify compression is active after reboot:

```bash
# Check if compression is enabled
sudo btrfs filesystem show /
sudo btrfs filesystem df /
```

## References

- [BTRFS Mount Options Documentation](https://btrfs.readthedocs.io/en/latest/btrfs-man5.html)
- [BTRFS SSD Optimization Guide](https://btrfs.wiki.kernel.org/index.php/SSD_Optimization)
- [Zstandard Compression](https://facebook.github.io/zstd/)

## License

Same as the parent repository.
