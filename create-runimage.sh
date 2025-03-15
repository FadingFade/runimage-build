#!/usr/bin/env bash
set -e
curl -o runimage -L https://github.com/VHSgunzo/runimage/releases/download/continuous/runimage-x86_64
chmod +x runimage

build_runimage() {
  set -e
  # List of packages to be installed into runimage
  PKGS_LIST=(
    pipewire-pulse pipewire-alsa jre17-openjdk zenity chromium steam prismlauncher-git mcpelauncher-ui-git mcpelauncher-linux-git wine-staging winetricks-git alsa-lib alsa-plugins cups dosbox
    ffmpeg giflib gnutls gst-plugins-base-libs gtk3 lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs
    lib32-gtk3 lib32-libcups lib32-libpulse lib32-libva lib32-libxcomposite lib32-libxinerama lib32-ocl-icd lib32-sdl2-compat lib32-v4l-utils
    lib32-vulkan-icd-loader libgphoto2 libpulse libva libxcomposite libxinerama ocl-icd samba sane sdl2-compat v4l-utils vulkan-icd-loader
  )
  # Check for updates
  rim-update

  # Install the specified packages
  pac -S --noconfirm "${PKGS_LIST[@]}"

  # Shrink the runimage rootfs
  rim-shrink --all

  # Build new runimage
  rim-build --sqfs --zstd --clvl 22 --bsize 1M runimage-x86_64
}

export -f build_runimage

# Execute the build function
RIM_OVERFS_MODE=1 RIM_NO_NVIDIA_CHECK=1 ./runimage bash -c build_runimage
