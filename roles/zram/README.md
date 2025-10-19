# Zram Role

Configures zram (compressed RAM swap) on the system to improve performance by using compressed memory instead of disk-based swap.

## Features

- Two configuration methods:
  - **Package method**: Uses the official `zram-config` package (recommended for simplicity)
  - **Manual method**: Custom systemd service for advanced configuration
- Configurable compression algorithms (lz4, lzo, zstd)
- Adjustable swap size as percentage of total RAM
- Optional disk swap removal
- Idempotent and secure

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `zram_method` | `package` | Installation method: `package` or `manual` |
| `zram_size_percent` | `50` | Zram size as percentage of total RAM (manual method) |
| `zram_compression_algorithm` | `lz4` | Compression algorithm: `lz4`, `lzo`, or `zstd` |
| `zram_swap_priority` | `100` | Swap priority (higher = preferred) |
| `zram_num_devices` | `1` | Number of zram devices to create |
| `zram_disable_disk_swap` | `false` | Disable traditional disk-based swap |

## Usage

The role is included in `workstation.yml` by default. To customize configuration, override variables in your `vars.yml`:

```yaml
# Use manual method with custom settings
zram_method: manual
zram_size_percent: 75
zram_compression_algorithm: zstd
zram_disable_disk_swap: true
```

## Compression Algorithms

- **lz4**: Fastest, lower compression ratio (recommended for most systems)
- **lzo**: Balanced speed and compression
- **zstd**: Best compression ratio, slightly slower

## Tags

- `zram`: All zram tasks
- `packages`: Package installation
- `services`: Service management
- `kernel`: Kernel module configuration
