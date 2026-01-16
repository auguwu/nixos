{
  nixpkgs,
  inputs,
  overlays,
}: let
  inherit (nixpkgs.lib) listToAttrs;
  inherit (inputs) hardware lanzaboote sops-nix;

  mkNixSystem = import ../lib/mkSystem.nixos.nix {
    inherit nixpkgs inputs overlays;
  };

  mkDarwinSystem = import ../lib/mkSystem.darwin.nix {
    inherit nixpkgs inputs overlays;
  };

  machines = {
    nixos = [
      {
        name = "floofbox";
        system = "x86_64-linux";
        withIDEs = true;
        withVSCode = true;
        gaming = true;

        modules = [
          hardware.nixosModules.common-cpu-amd
          hardware.nixosModules.common-gpu-amd

          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
        ];
      }

      {
        name = "kotoha";
        system = "x86_64-linux";
        withIDEs = true;
        withVSCode = true;

        modules = [
          hardware.nixosModules.framework-13-7040-amd

          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
        ];
      }

      {
        name = "hokkaido";
        system = "x86_64-linux";
        graphical = false;
      }
    ];

    darwin = [
      {
        name = "yuzu";
        system = "aarch64-darwin";
      }
    ];
  };
in {
  nixosConfigurations =
    listToAttrs (map ({
        name,
        system,
        modules ? [],
        graphical ? true,
        withIDEs ? false,
        withVSCode ? false,
        gaming ? false,
      }: {
        inherit name;

        value = mkNixSystem name {
          inherit system modules graphical withIDEs withVSCode gaming;
        };
      })
      machines.nixos)
    // {
      # TODO(@auguwu): iso-linux-x64 and iso-linux-aarch64
    };

  darwinConfigurations = listToAttrs (map ({
      name,
      system,
      modules ? [],
    }: {
      inherit name;

      value = mkDarwinSystem name {
        inherit system modules;

        withIDEs = true;
        withVSCode = true;
        graphical = true;
      };
    })
    machines.darwin);
}
