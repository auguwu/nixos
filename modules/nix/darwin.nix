{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.stable;
    optimise.automatic = true;
    gc = {
      automatic = true;
      interval.Day = 7;
    };

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["noel"];
      sandbox = true;

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://noel.cachix.org" # TODO: move to https://nix.noel.pink
        "https://noelware.cachix.org" # TODO: move to https://nix.noelware.org
      ];

      trusted-public-keys = [
        "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
        "noelware.cachix.org-1:22A8ELRjkqEycSHz+R5A5ReX2jyjU3rftsBmlD6thn0="
      ];

      substituters = [
        "https://noel.cachix.org"
        "https://noelware.cachix.org"
      ];
    };
  };
}
