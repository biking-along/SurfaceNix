{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/kappa/gnome/gnome.nix
    ../../modules/kappa/cachix/cachix.nix
    ../../modules/kappa/envVars.nix
    ../../modules/kappa/sp8Edid.nix
    ../../modules/kappa/nix.nix
    ../../modules/kappa/systemPkgs.nix
    ../../modules/shared/hideDesktopEntry.nix
    ../../modules/shared/nh.nix
    ../../modules/shared/git.nix
  ];

  systemd.coredump.enable = true;

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

  # Declare both to override base config for iso
  networking = {
    hostName = "kappa";
    wireless.enable = false;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.11";
}

