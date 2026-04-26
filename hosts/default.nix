{
  self,
  nixpkgs,
  inputs,
  overlays,
}: let
  inherit (nixpkgs.lib) listToAttrs;
  inherit (inputs) hardware lanzaboote sops-nix nix-minecraft;

  mkNixSystem = import ../lib/mkSystem.nixos.nix {
    inherit self nixpkgs inputs overlays;
  };

  mkDarwinSystem = import ../lib/mkSystem.darwin.nix {
    inherit self nixpkgs inputs overlays;
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

          nix-minecraft.nixosModules.minecraft-servers
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

        modules = [
          nix-minecraft.nixosModules.minecraft-servers
          sops-nix.nixosModules.sops
        ];
      }

      # {
      #   name = "akita";
      #   system = "x86_64-linux";
      #   graphical = false;
      #   modules = [
      #     sops-nix.nixosModules.sops
      #   ];
      # }
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
      iso-linux-x64 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit system nixpkgs;

          graphical = false;
          machine = "nixos-iso";
          flakeRoot = self;
        };

        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = {
              allowUnfree = true;
            };
          }

          ./iso
        ];
      };

      iso-linux-aarch64 = nixpkgs.lib.mkSystem rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit system inputs;

          graphical = false;
          machine = "nixos-iso";
          flakeRoot = self;
        };

        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }

          ./iso
        ];
      };
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
