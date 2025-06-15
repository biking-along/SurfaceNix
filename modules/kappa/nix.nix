{

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "rw" ];
    };
  };

  nixpkgs ={
    config.allowUnfree = true;
    overlays = [ (import ../../modules/kappa/gnome/overlay-osk.nix) ];
  };

}
