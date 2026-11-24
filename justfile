skills_home := env("HOME")
claude_config := env("CLAUDE_CONFIG_DIR", skills_home / ".claude")
agents_skills := skills_home / ".agents" / "skills"
unsloth_skills_override := trim(env("UNSLOTH_STUDIO_SKILLS_HOME", ""))
unsloth_skills := if unsloth_skills_override == "" { agents_skills } else if unsloth_skills_override =~ "^~(/|$)" { skills_home + trim_start_match(unsloth_skills_override, "~") } else { unsloth_skills_override }

[default]
@list:
    {{ quote(just_executable()) }} --list

# Link skills into Claude Code's personal skills directory.
install-claude: (_install (claude_config / "skills"))

# Link skills into ~/.agents/skills for Codex.
install-codex: (_install agents_skills)

# Link skills into Unsloth's skills directory (defaults to ~/.agents/skills).
install-unsloth: (_install unsloth_skills)

install: install-claude install-codex install-unsloth

# Link skills into a directory of your choice.
install-user-choice destination: (_install destination)

[no-cd]
[private]
_install $destination:
    #!/bin/sh
    set -eu

    if [ -z "$destination" ]; then
        printf 'Choose a non-empty destination directory.\n' >&2
        exit 1
    fi

    mkdir -p -- "$destination"
    repo={{ quote(justfile_directory()) }}
    status=0

    for skill in "$repo"/*; do
        [ -f "$skill/SKILL.md" ] || continue
        link="$destination/${skill##*/}"

        if [ -L "$link" ] && [ "$link" -ef "$skill" ]; then
            continue
        fi
        if [ -e "$link" ] || [ -L "$link" ]; then
            printf 'Warning: skipped existing entry: %s\n' "$link" >&2
            status=1
            continue
        fi

        if ln -sn -- "$skill" "$link"; then
            printf 'Linked %s -> %s\n' "$link" "$skill"
        elif ! { [ -L "$link" ] && [ "$link" -ef "$skill" ]; }; then
            status=1
        fi
    done

    exit "$status"
