{
  description = "Noel's dotfiles configuration for my devices that run NixOS";

  # Include the binary caches for my own projects and Noelware's as well.
  nixConfig = {
    extra-substituters = [
      # TODO: switch to https://nix.floofy.dev
      "https://noel.cachix.org"

      # TODO: switch to https://nix.noelware.org
      "https://noelware.cachix.org"
    ];

    extra-trusted-public-keys = [
      "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
      "noelware.cachix.org-1:22A8ELRjkqEycSHz+R5A5ReX2jyjU3rftsBmlD6thn0="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noelware = {
      url = "github:Noelware/nixpkgs-noelware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ume = {
      url = "github:auguwu/ume/4.2.1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noelware.follows = "noelware";
      };
    };

    vscode-insiders = {
      url = "github:auguwu/vscode-insiders-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    nixpkgs,
    hardware,
    darwin,
    sops-nix,
    noelware,
    vscode-insiders,
    ume,
    nix-vscode-extensions,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    inherit (lib) genAttrs;

    # only generate for systems i actually have
    eachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];
    overlays = [
      nix-vscode-extensions.overlays.default
      vscode-insiders.overlays.default
      darwin.overlays.default

      (import noelware)
    ];

    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs inputs overlays;
    };

    nixpkgsFor = system:
      import nixpkgs {
        inherit system;

        overlays = [
          (final: prev: {
            ume = ume.packages.${system}.ume;
          })
        ];
      };
  in {
    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
    nixosConfigurations = {
      floofbox = mkSystem "floofbox" {
        system = "x86_64-linux";
        modules = [
          hardware.nixosModules.common-cpu-amd
          hardware.nixosModules.common-gpu-amd

          sops-nix.nixosModules.sops
        ];
      };

      kotoha = mkSystem "kotoha" {
        system = "x86_64-linux";
        modules = [
          hardware.nixosModules.framework-13-7040-amd
        ];
      };
    };

    darwinConfigurations = {
      miki = mkSystem "miki" {
        system = "aarch64-darwin";
        darwin = true;
      };
    };
  };
}
