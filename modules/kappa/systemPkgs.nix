{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gawk
    wget
    iftop
    lm_sensors
    screen
    iptsd
    file
    binutils
    coreutils
    ghostty
    microfetch
    bitwarden-desktop
    jellyfin-media-player
    youtube-music
  ];
}
