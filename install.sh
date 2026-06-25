#!/usr/bin/env bash
# install.sh — link config directories from this repo into ~/.config/
# Re-runnable: existing configs are moved to ~/.config/.old_config/<timestamp>/
# before being replaced with symlinks. Correct symlinks are left alone.

set -euo pipefail

# Repo root = directory where this script lives (resolves through symlinks)
REPO="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

# Mapping: <dir-in-repo> -> <name-in-~/.config>
# Edit this list if your repo dirs are named differently.
declare -A MAP=(
    [hypr]=hypr
    [fish]=fish
    [kitty]=kitty
    [waybar]=waybar
    [dunst]=dunst
)

CONFIG="$HOME/.config"
BACKUP_ROOT="$CONFIG/.old_config"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP="$BACKUP_ROOT/$TIMESTAMP"

mkdir -p "$CONFIG"

backup_created=0

for src_name in "${!MAP[@]}"; do
    dst_name="${MAP[$src_name]}"
    src_path="$REPO/$src_name"
    dst_path="$CONFIG/$dst_name"

    # 1. Source must exist in the repo
    if [[ ! -d "$src_path" ]]; then
        printf "  ✗ %-10s skipped: %s not found in repo\n" "$dst_name" "$src_name"
        continue
    fi

    # 2. Already correctly linked? Nothing to do.
    if [[ -L "$dst_path" ]] && [[ "$(readlink -f "$dst_path")" == "$src_path" ]]; then
        printf "  · %-10s already linked, skipped\n" "$dst_name"
        continue
    fi

    # 3. Need to act — create timestamped backup dir on first use
    if [[ -e "$dst_path" || -L "$dst_path" ]] && (( backup_created == 0 )); then
        mkdir -p "$BACKUP"
        backup_created=1
    fi

    # 4. Move whatever is at the destination
    if [[ -L "$dst_path" ]]; then
        # Existing symlink points somewhere else (or is broken) — just drop it.
        rm "$dst_path"
        printf "  → %-10s old symlink removed\n" "$dst_name"
    elif [[ -e "$dst_path" ]]; then
        # Real file/dir — back it up
        mv "$dst_path" "$BACKUP/$dst_name"
        printf "  → %-10s moved to backup\n" "$dst_name"
    fi

    # 5. Create the new symlink (absolute target — never relative)
    ln -s "$src_path" "$dst_path"
    printf "  ✓ %-10s -> %s\n" "$dst_name" "$src_path"
done

echo
if (( backup_created )); then
    echo "Backup saved to: $BACKUP"
else
    echo "Nothing to back up — no real files were displaced."
fi
echo "Done."
