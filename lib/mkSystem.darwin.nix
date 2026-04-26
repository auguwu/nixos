{
  self,
  inputs,
  nixpkgs,
  overlays,
}: machine: {
  system,
  modules ? [],
  graphical ? true,
  withIDEs ? false,
  withVSCode ? false,
  gaming ? false,
}: let
  machineConfig = ../hosts/${machine}/configuration.nix;
  userConfig = ../users/noel/darwin.nix;
  home-manager = inputs.home-manager.darwinModules.home-manager;
in
  inputs.darwin.lib.darwinSystem {
    inherit system;

    specialArgs = {
      inherit graphical system inputs machine;

      flakeRoot = self;
    };

    modules = [
      {
        nixpkgs.overlays = overlays;
        nixpkgs.config.allowUnfree = true;
      }

      # include machine-specific configuration
      machineConfig

      # include the user configuration
      userConfig

      # Bring-in the home-manager module
      home-manager

      # Configure home-manager
      {
        home-manager = {
          backupFileExtension = "backup";
          useUserPackages = true;
          useGlobalPkgs = true;
          users.noel = import ../users/noel/home.nix;

          sharedModules = [
            inputs.draconis.homeModules.default
          ];

          extraSpecialArgs = {
            inherit graphical machine inputs system withIDEs withVSCode gaming;
          };
        };
      }
    ];
  }
