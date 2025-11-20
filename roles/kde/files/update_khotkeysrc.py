#!/usr/bin/env python3
"""
Update khotkeysrc with custom shortcuts commands.

Reads shortcuts from ~/.config/shortcuts.json.tmp (created by Ansible).
Writes command definitions to khotkeysrc in the proper INI format.
"""
import sys
import json
import configparser
from pathlib import Path
from io import StringIO

class CaseSensitiveConfigParser(configparser.ConfigParser):
    """ConfigParser that preserves case for option names"""
    def optionxform(self, optionstr):
        return optionstr

def update_khotkeysrc(user_home, shortcuts_data):
    """Update khotkeysrc file with command definitions for shortcuts"""

    khotkeys_path = Path(user_home) / ".config" / "khotkeysrc"

    # Read existing khotkeysrc
    config = CaseSensitiveConfigParser()
    try:
        config.read(str(khotkeys_path))
    except Exception as e:
        print(f"Warning: Could not read existing khotkeysrc: {e}", file=sys.stderr)

    # Ensure [Data] section exists
    if 'Data' not in config:
        config['Data'] = {}

    # Process each shortcut
    for idx, shortcut in enumerate(shortcuts_data, 1):
        uuid = f"{{00000000-0000-0000-0000-{idx:012d}}}"
        name = shortcut.get('name', 'Shortcut')
        command = shortcut.get('command', '')

        # Create Data_N section for the shortcut metadata
        data_section = f'Data_{idx}'
        if data_section not in config:
            config[data_section] = {}
        config[data_section]['Comment'] = name
        config[data_section]['Enabled'] = 'true'
        config[data_section]['Name'] = name
        config[data_section]['Type'] = 'SIMPLE_ACTION_DATA'

        # Create Data_NActions section
        actions_section = f'Data_{idx}Actions'
        if actions_section not in config:
            config[actions_section] = {}
        config[actions_section]['ActionsCount'] = '1'

        # Create Data_NActions0 section with the command
        action_section = f'Data_{idx}Actions0'
        if action_section not in config:
            config[action_section] = {}
        config[action_section]['CommandURL'] = command
        config[action_section]['Type'] = 'COMMAND_URL'

        # Create Data_NConditions section (empty)
        conditions_section = f'Data_{idx}Conditions'
        if conditions_section not in config:
            config[conditions_section] = {}
        config[conditions_section]['Comment'] = ''
        config[conditions_section]['ConditionsCount'] = '0'

        # Create Data_NTriggers section
        triggers_section = f'Data_{idx}Triggers'
        if triggers_section not in config:
            config[triggers_section] = {}
        config[triggers_section]['Comment'] = 'Simple_action'
        config[triggers_section]['TriggersCount'] = '1'

        # Create Data_NTriggers0 section with the key binding
        trigger_section = f'Data_{idx}Triggers0'
        if trigger_section not in config:
            config[trigger_section] = {}

        # Get the key from the global shortcuts data (kglobalshortcutsrc will have it)
        key = shortcut.get('key', '')
        if key.startswith('Super'):
            key = key.replace('Super', 'Meta')

        config[trigger_section]['Key'] = key
        config[trigger_section]['Type'] = 'SHORTCUT'
        config[trigger_section]['Uuid'] = uuid

        # Update [Data] section count
        config['Data']['DataCount'] = str(idx)

    # Write the updated config back to khotkeysrc
    try:
        with open(khotkeys_path, 'w') as f:
            config.write(f)
        print("changed=true")
        return 0
    except Exception as e:
        print(f"error: Could not write to khotkeysrc: {e}", file=sys.stderr)
        return 1

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: update_khotkeysrc.py <user_home>", file=sys.stderr)
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
        sys.exit(update_khotkeysrc(user_home, shortcuts))
    except Exception as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)
