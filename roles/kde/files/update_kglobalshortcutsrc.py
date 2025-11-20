#!/usr/bin/env python3
"""
Update the khotkeys section in kglobalshortcutsrc while preserving other settings.
"""
import sys
import json
import os
from pathlib import Path

def update_kglobalshortcutsrc(user_home, shortcuts_json):
    """Update khotkeys section in kglobalshortcutsrc"""
    config_path = Path(user_home) / ".config" / "kglobalshortcutsrc"

    # Parse shortcuts from JSON
    shortcuts = json.loads(shortcuts_json)

    # Read existing file or create new one
    if config_path.exists():
        with open(config_path, 'r') as f:
            content = f.read()
        lines = content.split('\n')
    else:
        lines = []

    # Find or create khotkeys section
    khotkeys_start = None
    khotkeys_end = None

    for i, line in enumerate(lines):
        if line.strip() == '[khotkeys]':
            khotkeys_start = i
        elif khotkeys_start is not None and line.startswith('[') and line != '[khotkeys]':
            khotkeys_end = i
            break

    # Build new khotkeys section
    new_khotkeys = ['[khotkeys]', '_k_friendly_name=Custom Shortcuts Service']

    for idx, shortcut in enumerate(shortcuts, 1):
        uuid = f"{{00000000-0000-0000-0000-{idx:012d}}}"
        key = shortcut.get('key', 'none')
        name = shortcut.get('name', 'Shortcut')
        new_khotkeys.append(f"{uuid}={key},none,{name}")

    # Add empty line after section
    new_khotkeys.append('')

    # Replace or insert khotkeys section
    if khotkeys_start is not None:
        if khotkeys_end is not None:
            # Replace existing section
            lines = lines[:khotkeys_start] + new_khotkeys + lines[khotkeys_end:]
        else:
            # Section goes to end of file
            lines = lines[:khotkeys_start] + new_khotkeys
    else:
        # Add new section before the first section if it exists, or at the beginning
        insert_pos = 0
        for i, line in enumerate(lines):
            if line.startswith('['):
                insert_pos = i
                break
        else:
            insert_pos = len(lines)

        lines = lines[:insert_pos] + new_khotkeys + lines[insert_pos:]

    # Write updated content
    with open(config_path, 'w') as f:
        f.write('\n'.join(lines))

    print("changed=true")
    return 0

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: update_kglobalshortcutsrc.py <user_home> <shortcuts_json>", file=sys.stderr)
        sys.exit(1)

    user_home = sys.argv[1]
    shortcuts_json = sys.argv[2]

    try:
        sys.exit(update_kglobalshortcutsrc(user_home, shortcuts_json))
    except Exception as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)
