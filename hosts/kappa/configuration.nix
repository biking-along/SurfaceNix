# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

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
  ];

  # enable core dumps.
  systemd.coredump.enable = true;

  networking.hostName = "kappa"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  boot.tmp.cleanOnBoot = true;
  hardware.enableAllFirmware = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    neovim
    # Hide neovim wrapper desktop entry
    (lib.hiPrio (pkgs.runCommand "nvim.desktop-hide" { } ''
      mkdir -p "$out/share/applications"
      cat "${config.programs.neovim.package}/share/applications/nvim.desktop" > "$out/share/applications/nvim.desktop"
      echo "Hidden=1" >> "$out/share/applications/nvim.desktop"
    ''))
    # Hide fish desktop entry
    (lib.hiPrio (pkgs.runCommand "fish.desktop-hide" { } ''
       mkdir -p "$out/share/applications"
       cat "${config.programs.fish.package}/share/applications/fish.desktop" > "$out/share/applications/fish.desktop"
       echo "Hidden=1" >> "$out/share/applications/fish.desktop"
     ''))
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

  networking.wireless.enable =
    false; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable mosh, and open firewall as appropriate.
  # programs.mosh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

