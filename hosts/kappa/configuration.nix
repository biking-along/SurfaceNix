{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/kappa
    ../../modules/shared/hideDesktopEntry.nix
    ../../modules/shared/nh.nix
    ../../modules/shared/git.nix
    ../../modules/shared/disk.nix
    ../../modules/shared/timeZone.nix
  ];

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

