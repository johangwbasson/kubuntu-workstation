# Networking Role

Configures DNS settings using systemd-resolved with Cloudflare for Families DNS and DNS over TLS.

## Features

- Configures Cloudflare for Families DNS (malware/adult content blocking)
- Enables DNS over TLS for encrypted DNS queries
- Configurable via variables

## Default Configuration

- **DNS Servers**: Cloudflare for Families (1.1.1.3, 1.0.0.3)
- **DNS over TLS**: Enabled
- **DNS Stub Listener**: Enabled

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `configure_custom_dns` | `true` | Enable/disable custom DNS configuration |
| `dns_servers` | Cloudflare list | List of DNS server IPs |
| `dns_over_tls` | `true` | Enable DNS over TLS (port 853) |
| `dns_stub_listener` | `true` | Enable systemd-resolved stub listener |

## VirtualBox VM Usage

**Important**: VirtualBox's NAT networking (10.0.2.3) doesn't support DNS over TLS, which causes DNS resolution to fail.

### Recommended Approach: Update .vars.yml

Add this to your `.vars.yml` file when testing in a VM:

```yaml
# .vars.yml
username: your-vm-username
git_name: Your Name
git_email: your@email.com

# Disable custom DNS for VirtualBox VMs
configure_custom_dns: false
```

Then run normally:
```bash
ansible-playbook workstation.yml
```

### Alternative: Use vars-vm.yml Override

For quick testing without modifying `.vars.yml`:

```bash
ansible-playbook workstation.yml -e @vars-vm.yml
```

### Other Options

**Disable DNS over TLS only** (keep Cloudflare DNS):
```yaml
# .vars.yml
dns_over_tls: false
```

**Use different DNS servers**:
```yaml
# .vars.yml
dns_servers:
  - 8.8.8.8
  - 8.8.4.4
dns_over_tls: false
```

## Troubleshooting

### DNS Not Working After Playbook Run

**Symptoms**: Cannot resolve domain names (e.g., github.com)

**Check DNS status**:
```bash
resolvectl status
```

**Quick fix** (temporary):
```bash
sudo rm /etc/systemd/resolved.conf.d/custom-dns.conf
sudo systemctl restart systemd-resolved
```

**Permanent fix**: Run playbook with `-e configure_custom_dns=false`

### Verify DNS Resolution

```bash
# Check DNS configuration
resolvectl status

# Test DNS lookup
dig github.com
nslookup github.com
```

## Tags

- `networking` - All networking tasks
- `dns` - DNS configuration tasks
- `cleanup` - Cleanup old configurations
