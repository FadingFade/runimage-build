#!/usr/bin/env bash

set -e

curl -OL "https://github.com/VHSgunzo/runimage/releases/download/continuous/runimage-x86_64"

chmod +x runimage-x86_64

run_install() {

set -e

INSTALL_PKGS=(
    wine-staging winetricks-git alsa-lib alsa-plugins cups dosbox ffmpeg giflib
    gnutls gst-plugins-base-libs gtk3 lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gnutls
    lib32-gst-plugins-base-libs lib32-gst-plugins-good lib32-gst-plugins-base lib32-gtk3
    lib32-libcups lib32-libpulse lib32-libva lib32-libxcomposite lib32-libxinerama lib32-ocl-icd
    lib32-sdl2-compat lib32-v4l-utils lib32-vulkan-icd-loader libgphoto2 libpulse libva
    libxcomposite libxinerama ocl-icd samba sane sdl2-compat v4l-utils vulkan-icd-loader
    steam prismlauncher mcpelauncher-linux-git mcpelauncher-ui-git pipewire-alsa pipewire-pulse
    zenity chromium jre8-openjdk wget
)

rim-update # Update runimage

pac --noconfirm -S "${INSTALL_PKGS[@]}" # Install packages

rim-shrink --all # Shrink runimage

cat << 'EOF' > "$RUNDIR/config/Run.rcfg"
RIM_SHARE_ICONS="${RIM_SHARE_ICONS:=1}"
RIM_SHARE_FONTS="${RIM_SHARE_FONTS:=1}"
RIM_SHARE_THEMES="${RIM_SHARE_THEMES:=1}"
RIM_SYS_NVLIBS="${RIM_SYS_NVLIBS:=1}"
EOF

rim-build --dwfs --lz4 --bsize 18 --clvl 0 runimage
}

export -f run_install

RIM_OVERFS_MODE=1 RIM_NO_NVIDIA_CHECK=1 ./runimage-x86_64 bash -c run_install
