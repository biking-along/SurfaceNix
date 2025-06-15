{ config, pkgs, lib, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ../../modules/kappa/gnome/gnome.nix
    ../../modules/kappa/cachix/cachix.nix
    ../../modules/kappa/envVars.nix
    ../../modules/kappa/sp8Edid.nix
    ../../modules/kappa/nix.nix
    ../../modules/shared/hideDesktopEntry.nix
    ../../modules/shared/nh.nix
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

  # Declare both to override base config for iso
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  documentation.nixos.enable = false;

  system.stateVersion = "25.11";

}

