# inspired by & credit for most of this goes to:
# https://github.com/mitchellh/nixos-config/blob/main/lib/mksystem.nix
{
  inputs,
  nixpkgs,
  overlays,
}: name: {
  system,
  darwin ? false,
  modules ? [],
  graphical ? true,
}: let
  machine = ../hosts/${name}/configuration.nix;
  userConfig =
    if darwin
    then {
      users.users.noel = {
        name = "noel";
        home = "/Users/noel";
      };
    }
    else ../users/noel;

  home-manager =
    if darwin
    then inputs.home-manager.darwinModules.home-manager
    else inputs.home-manager.nixosModules.home-manager;

  mkSystemFn =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;
in
  mkSystemFn {
    inherit system;

    specialArgs = {
      inherit machine;
    };

    modules =
      [
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays =
              [
                (final: prev: {
                  ume = inputs.ume.packages.${system}.ume;
                })
              ]
              ++ overlays;
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
