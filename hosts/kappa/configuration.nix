{ config, pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "rw" ];
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ (import ../../modules/kappa/gnome/overlay-osk.nix) ];

  imports = [
    ./hardware-configuration.nix
    ../../modules/kappa/gnome/gnome.nix
    ../../modules/kappa/cachix/cachix.nix
    ../../modules/kappa/envVars.nix
    ../../modules/shared/hideDesktopEntry.nix
  ];

  systemd.coredump.enable = true;

  networking.hostName = "kappa";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  boot.tmp.cleanOnBoot = true;
  hardware.enableAllFirmware = true;

  users.users.rw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
    interactiveShellInit = ''
      microfetch
    '';
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 3d";
    };
    flake = "/home/rw/NixOS/SurfaceNix/";
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        email = "bikingalong@pm.me";
	name = "bikingalong";
      };
      core = {
        editor = "nvim";
      };
    };
  };

  environment.systemPackages = (with pkgs; [
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
  ]);

  hardware.display.edid.packages = [
    (pkgs.runCommand "edid-custom" { } ''
      mkdir -p "$out/lib/firmware/edid"
      base64 -d > "$out/lib/firmware/edid/SP8vrr120.bin" <<'EOF'
      AP///////wAw5LEGoSQYAAAfAQSlGxJ4A+9wp1FMqCYOT1MAAAABAQEBAQEBAQEBAQEBAQEBAAAA
      /QAeePDwSAEKICAgICAgAAAA/gBMR0RfTVAxLjBfCiAgAAAA/gBMUDEyOVdUMjEyMTY2AQEBAQEB
      AQEBAQEBAQEBAQEBAQdwEy4AAAMBFH8VAQg/C08AB4AfAH8HTwBBAAcAAwEUfxUBCD8LTwAHgB8A
      fwcfCEEABwDFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkA==
      EOF
    '')
  ];

  # Declare both to override base config for iso
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  documentation.nixos.enable = false;

  system.stateVersion = "25.11";

}

