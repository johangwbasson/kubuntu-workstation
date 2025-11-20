#!/usr/bin/env python3
"""
Update khotkeysrc with custom shortcuts commands.

Reads shortcuts from ~/.config/shortcuts.json.tmp (created by Ansible).
Writes command definitions to khotkeysrc in the proper INI format while
preserving existing KDE-specific format markers like [$d].
"""
import sys
import json
from pathlib import Path
import re

def parse_khotkeysrc(content):
    """Parse khotkeysrc content into a dict preserving KDE format markers"""
    sections = {}
    current_section = None
    current_props = {}

    for line in content.split('\n'):
        line_stripped = line.strip()

        # Check if this is a section header
        if line_stripped.startswith('[') and line_stripped.endswith(']'):
            # Save previous section
            if current_section:
                sections[current_section] = current_props
            current_section = line_stripped
            current_props = {'_raw_header': line}  # Preserve original header with [$d] markers
        elif current_section and '=' in line:
            # Parse property
            key, value = line.split('=', 1)
            key = key.strip()
            current_props[key] = value

    # Save last section
    if current_section:
        sections[current_section] = current_props

    return sections

def write_khotkeysrc(sections):
    """Write sections back to khotkeysrc format preserving KDE markers"""
    lines = []
    for section_name, props in sections.items():
        # Use preserved raw header if available
        if '_raw_header' in props:
            lines.append(props['_raw_header'])
        else:
            lines.append(section_name)

        # Write properties
        for key, value in props.items():
            if not key.startswith('_'):  # Skip meta properties
                lines.append(f"{key}={value}")

        lines.append('')  # Blank line between sections

    return '\n'.join(lines)

def update_khotkeysrc(user_home, shortcuts_data):
    """Update khotkeysrc file with command definitions for shortcuts"""

    khotkeys_path = Path(user_home) / ".config" / "khotkeysrc"

    # Read existing khotkeysrc preserving KDE format
    try:
        with open(khotkeys_path, 'r') as f:
            content = f.read()
        sections = parse_khotkeysrc(content)
    except FileNotFoundError:
        sections = {}
    except Exception as e:
        print(f"Warning: Could not read existing khotkeysrc: {e}", file=sys.stderr)
        sections = {}

    # Ensure [Data] section exists
    if '[Data]' not in sections:
        sections['[Data]'] = {'_raw_header': '[Data]'}

    # Process each shortcut
    for idx, shortcut in enumerate(shortcuts_data, 1):
        uuid = f"{{00000000-0000-0000-0000-{idx:012d}}}"
        name = shortcut.get('name', 'Shortcut')
        command = shortcut.get('command', '')
        key = shortcut.get('key', '')

        if key.startswith('Super'):
            key = key.replace('Super', 'Meta')

        # Create Data_N section for the shortcut metadata
        data_section = f'[Data_{idx}]'
        if data_section not in sections:
            sections[data_section] = {'_raw_header': data_section}
        sections[data_section]['Comment'] = name
        sections[data_section]['Enabled'] = 'true'
        sections[data_section]['Name'] = name
        sections[data_section]['Type'] = 'SIMPLE_ACTION_DATA'

        # Create Data_NActions section
        actions_section = f'[Data_{idx}Actions]'
        if actions_section not in sections:
            sections[actions_section] = {'_raw_header': actions_section}
        sections[actions_section]['ActionsCount'] = '1'

        # Create Data_NActions0 section with the command
        action_section = f'[Data_{idx}Actions0]'
        if action_section not in sections:
            sections[action_section] = {'_raw_header': action_section}
        sections[action_section]['CommandURL'] = command
        sections[action_section]['Type'] = 'COMMAND_URL'

        # Create Data_NConditions section (empty)
        conditions_section = f'[Data_{idx}Conditions]'
        if conditions_section not in sections:
            sections[conditions_section] = {'_raw_header': conditions_section}
        sections[conditions_section]['Comment'] = ''
        sections[conditions_section]['ConditionsCount'] = '0'

        # Create Data_NTriggers section
        triggers_section = f'[Data_{idx}Triggers]'
        if triggers_section not in sections:
            sections[triggers_section] = {'_raw_header': triggers_section}
        sections[triggers_section]['Comment'] = 'Simple_action'
        sections[triggers_section]['TriggersCount'] = '1'

        # Create Data_NTriggers0 section with the key binding
        trigger_section = f'[Data_{idx}Triggers0]'
        if trigger_section not in sections:
            sections[trigger_section] = {'_raw_header': trigger_section}
        sections[trigger_section]['Key'] = key
        sections[trigger_section]['Type'] = 'SHORTCUT'
        sections[trigger_section]['Uuid'] = uuid

        # Update [Data] section count
        sections['[Data]']['DataCount'] = str(idx)

    # Write the updated config back to khotkeysrc
    try:
        with open(khotkeys_path, 'w') as f:
            f.write(write_khotkeysrc(sections))
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
