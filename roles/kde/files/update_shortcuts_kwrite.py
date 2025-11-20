#!/usr/bin/env python3
"""
Update KDE shortcuts using kwriteconfig5 (the proper KDE way).

Reads shortcuts from ~/.config/shortcuts.json.tmp (created by Ansible).
Uses kwriteconfig5 to set shortcuts in both kglobalshortcutsrc and khotkeysrc.

This approach:
- Uses KDE's official configuration tool (kwriteconfig5)
- Properly handles KDE's INI format with special markers like [$d]
- Preserves all existing configuration data
- Is idempotent (safe to run multiple times)
"""
import sys
import json
import subprocess
from pathlib import Path


def run_kwriteconfig(file_name, group, key, value):
    """Run kwriteconfig5 command to set a configuration value"""
    try:
        cmd = [
            'kwriteconfig5',
            '--file', file_name,
            '--group', group,
            '--key', key,
            value
        ]
        subprocess.run(cmd, check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Warning: kwriteconfig5 failed: {e.stderr.decode()}", file=sys.stderr)
        return False
    except FileNotFoundError:
        print("Error: kwriteconfig5 not found. Install kde-cli-tools.", file=sys.stderr)
        return False


def update_shortcuts(user_home, shortcuts_data):
    """Update KDE shortcuts using kwriteconfig5"""

    # Ensure [Data] section exists with count
    run_kwriteconfig('khotkeysrc', 'Data', 'DataCount', str(len(shortcuts_data)))

    # Configure each shortcut
    for idx, shortcut in enumerate(shortcuts_data, 1):
        uuid = f"{{00000000-0000-0000-0000-{idx:012d}}}"
        name = shortcut.get('name', 'Shortcut')
        key = shortcut.get('key', '')
        command = shortcut.get('command', '')

        # Convert Super to Meta for KDE compatibility
        if key.startswith('Super'):
            key = key.replace('Super', 'Meta')

        # 1. Set in kglobalshortcutsrc [khotkeys] section
        # Format: {uuid}=key,,description
        kglobal_value = f"{key},,{name}" if key else f",,{name}"
        run_kwriteconfig('kglobalshortcutsrc', 'khotkeys', uuid, kglobal_value)

        # 2. Set metadata in khotkeysrc [Data_N] section
        run_kwriteconfig('khotkeysrc', f'Data_{idx}', 'Comment', name)
        run_kwriteconfig('khotkeysrc', f'Data_{idx}', 'Enabled', 'true')
        run_kwriteconfig('khotkeysrc', f'Data_{idx}', 'Name', name)
        run_kwriteconfig('khotkeysrc', f'Data_{idx}', 'Type', 'SIMPLE_ACTION_DATA')

        # 3. Set actions count in [Data_NActions]
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Actions', 'ActionsCount', '1')

        # 4. Set command in [Data_NActions0]
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Actions0', 'CommandURL', command)
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Actions0', 'Type', 'COMMAND_URL')

        # 5. Set conditions in [Data_NConditions]
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Conditions', 'Comment', '')
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Conditions', 'ConditionsCount', '0')

        # 6. Set trigger info in [Data_NTriggers]
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Triggers', 'Comment', 'Simple_action')
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Triggers', 'TriggersCount', '1')

        # 7. Set actual key binding in [Data_NTriggers0]
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Triggers0', 'Key', key)
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Triggers0', 'Type', 'SHORTCUT')
        run_kwriteconfig('khotkeysrc', f'Data_{idx}Triggers0', 'Uuid', uuid)

    return True


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: update_shortcuts_kwrite.py <user_home>", file=sys.stderr)
        sys.exit(1)

    user_home = sys.argv[1]
    shortcuts_file = Path(user_home) / ".config" / "shortcuts.json.tmp"

    # Read shortcuts from temporary JSON file
    try:
        with open(shortcuts_file, 'r') as f:
            shortcuts = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"error: Failed to read shortcuts from {shortcuts_file}: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        if update_shortcuts(user_home, shortcuts):
            print("changed=true")
            sys.exit(0)
        else:
            print("error: Failed to update shortcuts", file=sys.stderr)
            sys.exit(1)
    except Exception as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)
