# inspired by & credit for most of this goes to:
# https://github.com/mitchellh/nixos-config/blob/main/lib/mksystem.nix
{
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
  userConfig = ../users/noel/nixos.nix;
  home-manager = inputs.home-manager.nixosModules.home-manager;
in
  nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit graphical system inputs machine;
    };

    modules =
      [
        # Configures the system's nixpkgs
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;
        }

        # Include the machine-specific configuration
        machineConfig

        # Include the NixOS-specific user configuration
        userConfig

        # Bring in the home-manager module
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
      ]
      ++ modules; # include other modules that were defined
  }
