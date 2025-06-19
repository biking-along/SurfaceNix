# NixOS 

This is a flake for my desktop and laptop/tablet; Gamma and Kappa.
-Gamma is a x86-64 desktop gaming pc with and Intel CPU and an AMD GPU. 
-Kappa is a Microsoft Surface Pro 8. 
The kappa configs are originally forked from [IWander's](https://github.com/iwanders/nixos-surface) Surface Pro 9 config.

## Useful links;

- [NixOS configuration options](https://nixos.org/manual/nixos/unstable/options)

## Useful Commands;

### Build top level:
To build the top level filesystem result
```
nix build .#nixosConfigurations.HOSTNAME.config.system.build.toplevel
```
When large local builds have to happen, add `-L` for logging and set the amount of build cores;
```
NIX_BUILD_CORES=10 nix build .#nixosConfigurations.HOSTNANE.config.system.build.toplevel -L
```
Then, we can copy closure that with (assuming `rw` is in `trusted-users`):
```
nix copy --to "ssh://rw@HOSTNAME" ./result
```

### Actually switch to the new config
```
nixos-rebuild switch --flake .#HOSTNAME
```

### Format this repo
```
nix fmt
```

### Build the recovery image
The `flake.nix` file has some custom settings for generating a recovery image that includes this repository in the `/home/nixos/nixos-surface/` path.

The USB image can be built with:
```
nix build .#nixosConfigurations.surfaceRecovery.config.system.build.isoImage --out-link recovery.priv.result -L
```

## Misc config

Give gnome minimize and maximize buttons;
```
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
```
(Default is `appmenu:close`).

# Flake reminders

- This flake is always available in `/run/booted-system/flake/`, flake `current` is that.
- The `current#pkgs` points to `nixosConfigurations.kappa.pkgs`.
- The `nixpkgs#` flake points at the pinned upstream nixpkgs without overlays.



