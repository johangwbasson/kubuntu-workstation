# Flatpak Installation Rationale

This document explains why certain applications remain installed via Flatpak instead of being converted to APT repository installations.

## Applications Remaining as Flatpak

### 1. Bitwarden (`roles/bitwarden`)

**Reason:** No official APT repository available

**Details:**
- Bitwarden does not provide an official APT repository for Debian/Ubuntu
- Official installation methods:
  - Direct `.deb` download (requires manual updates)
  - Snap package
  - Flatpak (via Flathub)
- Community experimental repo exists (apt.fury.io/bitwarden) but is not officially supported

**Flatpak Advantages:**
- ✅ Official distribution method
- ✅ Automatic updates via Flatpak
- ✅ Sandboxed for enhanced security
- ✅ Better than manual `.deb` downloads

**Alternatives Considered:**
- `.deb` download: Rejected due to manual update requirements
- Snap: Similar to Flatpak but Flatpak is already required by other roles
- Community repo: Rejected due to lack of official support

---

### 2. Chromium (`roles/chromium`)

**Reason:** Ubuntu distributes Chromium as snap-only; Flatpak is best alternative

**Details:**
- Ubuntu made Chromium snap-only in Ubuntu 20.04+
- No official PPAs or APT repositories maintained by Chromium/Ubuntu
- Third-party PPAs exist but are not officially supported

**Flatpak Advantages:**
- ✅ Official Chromium distribution on Flathub
- ✅ Better sandboxing than snap (according to some users)
- ✅ Automatic updates
- ✅ Works across all distributions
- ✅ Avoids Ubuntu's forced snap packaging

**Alternatives Considered:**
- Ubuntu snap: Works but Flatpak provides similar benefits
- Third-party PPA (Savoury1): Rejected due to lack of official support and security concerns
- Building from source: Too complex and no automatic updates

---

### 3. Postman (`roles/postman`)

**Reason:** No official APT repository; Postman officially recommends Snap

**Details:**
- Postman does not provide an official APT repository
- Official installation methods:
  - Snap package (officially recommended by Postman)
  - Tarball download (manual installation)
  - Flatpak (via Flathub)
- Unofficial PPA exists (ppa:tiagohillebrandt/postman) but is community-maintained

**Flatpak Advantages:**
- ✅ Automatic updates (like Snap)
- ✅ Sandboxed application
- ✅ Consistent with other Flatpak applications
- ✅ Better than manual tarball installation
- ✅ Avoids mixing Snap and Flatpak management

**Alternatives Considered:**
- Snap: Official recommendation, but Flatpak provides similar functionality
- Tarball: Rejected due to manual installation and updates
- Unofficial PPA: Rejected due to lack of official support

---

## Applications Converted to APT Repositories

The following applications were converted from Flatpak to APT repository installations because they have official, maintained repositories:

### ✅ Slack → Official APT repository (PackageCloud)
- Repository: `https://packagecloud.io/slacktechnologies/slack/debian`
- GPG signed packages
- Automatic updates via apt

### ✅ Spotify → Official APT repository
- Repository: `http://repository.spotify.com`
- GPG signed packages (key rotates occasionally)
- Automatic updates via apt

### ✅ Insomnia → Kong APT repository
- Repository: `https://packages.konghq.com/public/insomnia/deb/ubuntu`
- GPG signed packages
- Automatic updates via apt

### ✅ Obsidian → Official APT repository
- Repository: `https://download.obsidian.md/linux-repo`
- GPG signed packages
- Automatic updates via apt

---

## Decision Criteria

An application should use APT repository if:
1. ✅ Official APT repository exists
2. ✅ Repository is actively maintained
3. ✅ Packages are GPG signed
4. ✅ Automatic updates available

An application should use Flatpak if:
1. ❌ No official APT repository exists
2. ✅ Available on Flathub (official Flatpak repository)
3. ✅ Provides automatic updates
4. ✅ Sandboxing is beneficial for the application
5. ✅ Better than manual installation methods

---

## Security Considerations

### APT Repository Benefits:
- Native package management
- GPG signature verification
- System-wide integration
- Trusted upstream sources

### Flatpak Benefits:
- Application sandboxing
- Limited filesystem access
- Controlled permissions (via Flatseal)
- Distribution-independent
- Curated Flathub repository

Both methods are secure when using official sources. The choice depends on availability and maintenance of official repositories.

---

**Document Version:** 1.0
**Last Updated:** 2025-11-03
**Maintained By:** Infrastructure Team
