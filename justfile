set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

skills_home := if os() == "windows" { env("HOME", env("USERPROFILE")) } else { env("HOME") }
claude_config := env("CLAUDE_CONFIG_DIR", skills_home / ".claude")
codex_config := env("CODEX_HOME", skills_home / ".codex")
agents_skills := skills_home / ".agents" / "skills"
unsloth_skills_override := trim(env("UNSLOTH_STUDIO_SKILLS_HOME", ""))
home_override_pattern := if os() == "windows" { '^~([/\\]|$)' } else { '^~(/|$)' }
unsloth_skills := if unsloth_skills_override == "" { agents_skills } else if unsloth_skills_override =~ home_override_pattern { skills_home + trim_start_match(unsloth_skills_override, "~") } else { unsloth_skills_override }

export SKILLS_JUST_EXECUTABLE := just_executable()
export SKILLS_REPO := justfile_directory()

[default]
[unix]
@list:
    {{ quote(just_executable()) }} --list

[windows]
@list:
    & $env:SKILLS_JUST_EXECUTABLE --list; exit $LASTEXITCODE

# Link skills into Claude Code's personal skills directory.
install-claude: (_install (claude_config / "skills"))

# Link skills into Codex's personal skills directory (defaults to ~/.codex/skills).
install-codex: (_install (codex_config / "skills"))

# Link skills into Unsloth's skills directory (defaults to ~/.agents/skills).
install-unsloth: (_install unsloth_skills)

install: install-claude install-codex install-unsloth

# Link skills into a directory of your choice.
install-user-choice destination: (_install destination)

[no-cd]
[private]
[unix]
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
            continue
        fi

        if ln -sn -- "$skill" "$link"; then
            printf 'Linked %s -> %s\n' "$link" "$skill"
        elif ! { [ -L "$link" ] && [ "$link" -ef "$skill" ]; }; then
            status=1
        fi
    done

    exit "$status"

[no-cd]
[private]
[windows]
[script("powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
_install $destination:
    $ErrorActionPreference = 'Stop'
    if ([string]::IsNullOrEmpty($env:destination)) {
        throw 'Choose a non-empty destination directory.'
    }

    $destination = [IO.Path]::GetFullPath($env:destination)
    [IO.Directory]::CreateDirectory($destination) | Out-Null
    $status = 0
    foreach ($skill in Get-ChildItem -LiteralPath $env:SKILLS_REPO -Directory) {
        if (-not [IO.File]::Exists((Join-Path $skill.FullName 'SKILL.md'))) {
            continue
        }

        $link = Join-Path $destination $skill.Name
        try {
            New-Item -ItemType Junction -Path $link -Target $skill.FullName | Out-Null
            Write-Output "Linked $link -> $($skill.FullName)"
        } catch {
            $existing = Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue
            if ($existing.LinkType -in 'Junction', 'SymbolicLink') {
                $target = $existing.Target | Select-Object -First 1
                if ($target) {
                    if (-not [IO.Path]::IsPathRooted($target)) {
                        $target = Join-Path $destination $target
                    }
                    if ([IO.Path]::GetFullPath($target).TrimEnd('\', '/') -eq $skill.FullName) {
                        continue
                    }
                }
            }
            if ($existing) {
                Write-Warning "Skipped existing entry: $link"
                continue
            }
            Write-Warning "Could not link ${link}: $($_.Exception.Message)"
            $status = 1
        }
    }
    exit $status
