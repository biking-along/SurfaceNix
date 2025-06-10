{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware }: rec {
    nixosConfigurations.kappa = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration-base.nix
        ./configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel

        {
          system.extraSystemBuilderCmds = ''
            ln -s ${self} $out/flake
            ln -s ${self.nixosConfigurations.kappa.config.boot.kernelPackages.kernel.dev} $out/kernel-dev
          '';
        }

        { nix.registry.nixpkgs.flake = nixpkgs; }

        {
          nix.registry.current.to = {
            type = "path";
            path = "/run/booted-system/flake/";
          };
        }
      ];
    };

    # nix build .#nixosConfigurations.recovery.config.system.build.isoImage
    nixosConfigurations.recovery = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration-base.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel

        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ({ pkgs, ... }: { environment.systemPackages = [ pkgs.vim ]; })

        {
          isoImage.squashfsCompression = "gzip -Xcompression-level 1";

          boot.supportedFilesystems = nixpkgs.lib.mkForce [
            "btrfs"
            "ext4"
            "f2fs"
            "ntfs"
            "vfat"
            "xfs"
            #"zfs"
          ];
        }

        {
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
        }

        ({ pkgs, ... }: {
          services.getty.helpLine = ''
            Exit the prompt to see this help again.
            The nixos-surface repo can be found at /home/nixos/nixos-surface/.
          '';

          boot.postBootCommands = ''
            ln -s ${self} /home/nixos/nixos-surface
          '';
        })
      ];
    };

    pkgs = nixosConfigurations.kappa.pkgs;

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
  };
}
