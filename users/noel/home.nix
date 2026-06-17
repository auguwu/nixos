{
  pkgs,
  lib,
  machine,
  graphical ? false,
  withVSCode ? false,
  withIDEs ? false,
  gaming ? false,
  ...
}: let
  homedir =
    if pkgs.stdenv.isDarwin
    then "/Users/noel"
    else "/home/noel";

  # from https://github.com/nix-community/home-manager/issues/3447#issuecomment-2213029759
  buildAutoStartFiles = apps: let
    inherit (lib) map attrsets;
  in
    builtins.listToAttrs (map (pkg: {
        name = ".config/autostart/${pkg.pname}.desktop";
        value =
          if pkg ? desktopItem
          then {
            # application has a `desktopItem` entry; we don't know
            # if it was made with `makeDesktopEntry`, which has a `text`
            # attribute of the content, so we'll assume that it's there.
            text = pkg.desktopItem.text;
          }
          else {
            source = let
              inherit (lib) head;

              appsPath = "${pkg}/share/applications";
              filterFiles = contents: attrsets.filterAttrs (_: ty: builtins.elem ty ["regular" "symlink"]) contents;
            in (
              if (builtins.pathExists "${appsPath}/${pkg.pname}.desktop")
              then "${appsPath}/${pkg.pname}.desktop"
              else
                (
                  if builtins.pathExists appsPath
                  then "${appsPath}/${head (builtins.attrNames (filterFiles (builtins.readDir appsPath)))}"
                  else throw "[${pkg.pname}]: unable to find `.desktop` entry"
                )
            );
          };
      })
      apps);

  rebuild-system = pkgs.callPackage ../../pkgs/rebuild-system {inherit machine;};
in {
  imports =
    [
      ./applications/draconis.nix
      ./applications/bat.nix
      ./applications/eza.nix
      ./applications/git.nix
      ./applications/zsh.nix

      ../../modules/graphical/hyfetch.nix
    ]
    ++ lib.optionals graphical [
      ../../modules/graphical/programs.nix
      ../../modules/graphical/ghostty.nix
    ]
    ++ lib.optionals withVSCode [
      ../../modules/graphical/vscode.nix
    ]
    ++ lib.optionals withIDEs [
      ../../modules/graphical/jetbrains.nix

      ./applications/gh.nix
    ]
    ++ lib.optionals gaming [
      ../../modules/gaming/minecraft.nix
    ];

  home = {
    packages = [
      rebuild-system
    ];

    sessionVariables = {
      EDITOR = "nano";
      VISUAL = "code-insiders";
    };

    shellAliases = {
      grep = "rg";
      cat = "bat -p";
      df = "duf -theme dark -only local";
      ls = "eza -l -S -F -a";
      dc = "docker compose";
    };

    homeDirectory = homedir;
    stateVersion = "23.05";
    username = lib.mkForce "noel";
    file = lib.mkIf (graphical && machine != "yuzu") (buildAutoStartFiles (with pkgs;
        [
          (discord-canary.override {
            withVencord = true;
          })

          telegram-desktop
          spotify
          firefox
        ]
        ++ lib.optionals gaming [
          steam
        ])
      // {
        ".wallpapers/littlearrowdog".source = ../../wallpapers/littlearrowdog.jpg;
      });
  };

  # Allow home-manager to manage itself
  programs.home-manager.enable = true;

  # le gpg
  programs.gpg.enable = true;
}
