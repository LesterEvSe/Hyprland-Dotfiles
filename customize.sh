#!/usr/bin/env bash
# customize.sh — fresh Arch -> personal Hyprland setup
#
# Run from inside the repo directory after a clean Arch install.
# Each stage is a function — comment out anything you don't want.
# Re-running is safe: pacman uses --needed, AUR/yay too.
#
# This script does NOT touch ~/.config — that's install.sh's job.
# At the end it offers to call install.sh for you.

set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

# ---- pretty printing ----
log()  { printf "\n\033[1;36m==> %s\033[0m\n" "$*"; }
warn() { printf "\033[1;33m!! %s\033[0m\n" "$*" >&2; }
err()  { printf "\033[1;31mXX %s\033[0m\n" "$*" >&2; }


# ============================================================
#  STAGE 1 — system upgrade + base build tools
# ============================================================
stage_system_update() {
    log "Stage 1/9 — system upgrade and build tools"
 
    # Enable [multilib] if not already (Steam and other 32-bit packages need it)
    if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
        warn "[multilib] is disabled in /etc/pacman.conf"
        warn "Steam and 32-bit packages won't be installable until you enable it."
        warn "To enable: uncomment the [multilib] section and its Include line, then re-run."
        warn "Skipping multilib-dependent installs in stage 7."
        export MULTILIB_AVAILABLE=0
    else
        export MULTILIB_AVAILABLE=1
    fi
 
    sudo pacman -Syu --noconfirm --needed git base-devel
}



# ============================================================
#  STAGE 2 — bootstrap yay (AUR helper)
# ============================================================
stage_install_yay() {
    log "Stage 2/9 — yay (AUR helper)"

    if command -v yay >/dev/null 2>&1; then
        echo "yay already installed, skipping"
        return
    fi

    local tmp
    tmp="$(mktemp -d)"
    
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    ( cd "$tmp/yay" && makepkg -si --noconfirm )
    rm -rf "$tmp"
}


# ============================================================
#  STAGE 3 — Hyprland core + session essentials
# ============================================================
stage_hyprland_core() {
    log "Stage 3/9 — Hyprland core stack"

    sudo pacman -S --noconfirm --needed \
        hyprland hyprlock hyprpaper hypridle \
        xdg-desktop-portal-hyprland \
        polkit hyprpolkitagent \
        qt6-wayland qt5-wayland
}


# ============================================================
#  STAGE 4 — terminal, shell, audio, Wayland utilities
# ============================================================
stage_userspace() {
    log "Stage 4/9 — terminal, shell, audio, utilities"

    sudo pacman -S --noconfirm --needed \
        kitty fish \
        pipewire pipewire-pulse wireplumber pavucontrol \
        bluez bluez-utils blueman \
        grim slurp swappy wl-clipboard \
        brightnessctl playerctl swayidle gammastep \
        jq htop dunst libnotify
}


# ============================================================
#  STAGE 5 — bar
# ============================================================
stage_bar() {
    log "Stage 5/9 — waybar + tray dependencies"

    sudo pacman -S --noconfirm --needed \
        waybar \
        libappindicator-gtk3 \
        network-manager-applet \
        filelight
}


# ============================================================
#  STAGE 6 — fonts (the icon problem solver)
# ============================================================
stage_fonts() {
    log "Stage 6/9 — fonts (this fixes missing icons)"

    # Repo fonts: full Nerd Font collection + symbols fallback + emoji
    sudo pacman -S --noconfirm --needed \
        ttf-jetbrains-mono-nerd \
        ttf-firacode-nerd \
        ttf-nerd-fonts-symbols \
        ttf-nerd-fonts-symbols-mono \
        ttf-nerd-fonts-symbols-common \
        noto-fonts noto-fonts-emoji noto-fonts-cjk \
        ttf-dejavu

    # Apple SF Pro for hyprlock — AUR. Falls back to -fixed if checksum drifts.
    yay -S --noconfirm --needed otf-apple-sf-pro \
        || yay -S --noconfirm --needed otf-apple-sf-pro-fixed \
        || warn "SF Pro fonts failed to install; hyprlock will use a fallback"
 
    # Enable Nerd Font Symbols as global fontconfig fallback.
    if [[ -f /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf \
       && ! -e /etc/fonts/conf.d/10-nerd-font-symbols.conf ]]; then
        sudo ln -s /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf \
                   /etc/fonts/conf.d/
    fi
 
    # Refresh fontconfig cache
    fc-cache -f

}


# ============================================================
#  STAGE 7 — applications from official repos
# ============================================================
stage_apps_repo() {
    log "Stage 7/9 — desktop applications (repos)"

    sudo pacman -S --noconfirm --needed \
        firefox \
        telegram-desktop \
        dolphin \
        steam
    
    if [[ "${MULTILIB_AVAILABLE:-0}" == "1" ]]; then
        sudo pacman -S --noconfirm --needed steam
    else
        warn "Skipping steam — enable [multilib] in /etc/pacman.conf and re-run."
    fi
}


# ============================================================
#  STAGE 8 — applications from AUR
# ============================================================
stage_apps_aur() {
    log "Stage 8/9 — desktop applications (AUR)"

    yay -S --noconfirm --needed \
        visual-studio-code-bin \
        google-chrome \
        vesktop-bin \
        spotify-launcher \
        obsidian-bin \
        neofetch \
        xkb-switch
}


# ============================================================
#  STAGE 9 — user environment (groups, shell, directories, assets)
# ============================================================
stage_user_env() {
    log "Stage 9/9 — user environment"

    # Add user to input group (needed for some keyboard tools)
    sudo usermod -aG input "$USER"

    # Make sure fish is a registered login shell
    if ! grep -qF "$(command -v fish)" /etc/shells; then
        command -v fish | sudo tee -a /etc/shells >/dev/null
    fi

    # Switch default shell to fish (does nothing if already fish)
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v fish)" ]]; then
        chsh -s "$(command -v fish)"
    fi

    # Asset directories
    mkdir -p "$HOME/Pictures/screenshots"
    mkdir -p "$HOME/Pictures/wallpapers"

    # Copy bundled images from repo (only if present)
    if [[ -d "$REPO/Pictures" ]]; then
        [[ -f "$REPO/Pictures/archlinux-logo.png" ]] && \
            cp -n "$REPO/Pictures/archlinux-logo.png" "$HOME/Pictures/"
        [[ -f "$REPO/Pictures/girl-cat-night.jpeg" ]] && \
            cp -n "$REPO/Pictures/girl-cat-night.jpeg" "$HOME/Pictures/wallpapers/"
        [[ -f "$REPO/Pictures/nature-and-deer.jpg" ]] && \
            cp -n "$REPO/Pictures/nature-and-deer.jpg" "$HOME/Pictures/wallpapers/"
    fi

    # Enable user services for the hypr ecosystem (best with uwsm; harmless otherwise)
    systemctl --user enable --now hyprpolkitagent.service 2>/dev/null || true
}


# ============================================================
#  Optional: link configs via the dedicated install.sh
# ============================================================
stage_link_configs() {
    log "Linking configs into ~/.config"
    if [[ -x "$REPO/install.sh" ]]; then
        "$REPO/install.sh"
    else
        warn "install.sh not found or not executable. Skipping config linking."
        warn "Run it manually later: chmod +x $REPO/install.sh && $REPO/install.sh"
    fi
}


# ============================================================
#  Main
# ============================================================
main() {
    stage_system_update
    stage_install_yay
    stage_hyprland_core
    stage_userspace
    stage_bar
    stage_fonts
    stage_apps_repo
    stage_apps_aur
    stage_user_env
    stage_link_configs

    log "All done."
    echo
    echo "Reboot recommended (group membership and shell change take effect on next login)."
    read -rp "Reboot now? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] && reboot || true
}

main "$@"
