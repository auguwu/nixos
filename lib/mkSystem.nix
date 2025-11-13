# inspired by & credit for most of this goes to:
# https://github.com/mitchellh/nixos-config/blob/main/lib/mksystem.nix
{
  inputs,
  nixpkgs,
  overlays,
}: name: {
  system,
  modules ? [],
  graphical ? true,
}: let
  machine = ../hosts/${name}/configuration.nix;
  userConfig = ../users/noel;
  home-manager = inputs.home-manager.nixosModules.home-manager;
  mkSystem = nixpkgs.lib.nixosSystem;
in
  mkSystem {
    inherit system;

    specialArgs = {
      inherit machine;
    };

    modules =
      [
        {
          nixpkgs = {
            inherit overlays;

            config.allowUnfree = true;
          };
        }

        # Include machine-specific configuration from `hosts/$NAME/configuration.nix`
        machine

        # Defines the `noel` user
        userConfig

        # Bring in `home-manager`
        home-manager

        # Configure home-manager
        {
          home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            users.noel = import ../users/noel/home.nix;

            extraSpecialArgs = {
              inherit graphical;
              machine = name;
            };
          };
        }
      ]
      ++ modules;
  }
