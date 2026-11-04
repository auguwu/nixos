{
  description = "noel@{floofbox,kotoha,yuzu,hokkaido}: nix flake configuration for my machines";
  nixConfig = {
    extra-substituters = [
      "https://noel.cachix.org" # https://nix.noel.pink
      "https://noelware.cachix.org" # https://nix.noelware.org
    ];

    extra-trusted-public-keys = [
      "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
      "noelware.cachix.org-1:22A8ELRjkqEycSHz+R5A5ReX2jyjU3rftsBmlD6thn0="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware";
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    draconis = {
      url = "github:skulldogged/draconisplusplus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    draconis-plugins = {
      url = "github:skulldogged/draconisplusplus-plugins";
      flake = false;
    };

    noelware = {
      url = "github:Noelware/nixpkgs-noelware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ume = {
      url = "github:auguwu/ume/4.2.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noelware.follows = "noelware";
      };
    };

    vscode-insiders = {
      url = "github:auguwu/vscode-insiders-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    hardware,
    noelware,
    vscode-insiders,
    nix-vscode-extensions,
    lanzaboote,
    darwin,
    nix-minecraft,
    ume,
    nh,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    patchedOverlays = [
      (final: prev: {
        vencord = prev.vencord.overrideAttrs (old: rec {
          version = "1.15.16";
          src = prev.fetchFromGitHub {
            owner = "Vendicated";
            repo = "Vencord";
            tag = "v${version}";
            hash = "sha256-aUJubLJpyLAZWiOezqFxPY6oVPgWVPQpajFqrJvrO9U=";
          };

          patches = [];
          postPatch = "";
          pnpmDeps = prev.fetchPnpmDeps {
            inherit (old) pname;
            inherit version src patches postPatch;

            pnpm = prev.pnpm_11;
            fetcherVersion = 4;
            hash = "sha256-HS8uZNepvDefjrsG3buVLFCVv7sHvazcwdpcT3EQ/78=";
          };
        });
      })
    ];

    overlays =
      [
        nix-vscode-extensions.overlays.default
        vscode-insiders.overlays.default
        darwin.overlays.default
        nix-minecraft.overlay
        # ume.overlays.default
        nh.overlays.default

        (import noelware)
        (import ./pkgs)
      ]
      ++ patchedOverlays;

    eachSystem = f:
      lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (system:
        f (import nixpkgs {
          inherit system overlays;

          config.allowUnfree = true;
        }));
  in {
    inherit (import ./hosts {inherit self nixpkgs inputs overlays;}) nixosConfigurations darwinConfigurations;

    formatter = eachSystem (pkgs: pkgs.alejandra);
    packages = eachSystem (pkgs: import ./pkgs {} pkgs);

    isos = builtins.listToAttrs (map (system: {
      name = system;
      value = self.nixosConfigurations."iso-${system}".config.system.build.isoImage;
    }) ["linux-x64" "linux-aarch64"]);

    # This will allow to build `noel@{hokkaido,akita,dva}` as a virtual-machine for testing
    # also the ISOs in case if they fail to work
    vms = builtins.listToAttrs (map (vm: {
        name = vm;
        value = self.nixosConfigurations.${vm}.config.system.build.vm;
      }) [
        "hokkaido"
        "akita"
        "dva"
      ]);
  };
}
