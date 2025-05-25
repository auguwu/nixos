{
  pkgs,
  lib,
  graphical ? false,
  machine,
  ...
}: let
  homedir =
    if pkgs.stdenv.isDarwin
    then "/Users/noel"
    else "/home/noel";

  # based off
  # https://github.com/nix-community/home-manager/issues/3447#issuecomment-2213029759
  buildAutoStartFiles = applications:
    if machine == "miki"
    then {}
    else let
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
              # otherwise, we'll try to find a .desktop item in the source
              # tree of the derivation of `pkg`.
              source = with builtins; let
                appsPath = "${pkg}/share/applications";
                filterFiles = contents:
                  attrsets.filterAttrs (
                    _: ty:
                      elem ty ["regular" "symlink"]
                  )
                  contents;
              in (
                if (pathExists "${appsPath}/${pkg.pname}.desktop")
                then "${appsPath}/${pkg.pname}.desktop"
                else
                  (
                    if pathExists appsPath
                    then "${appsPath}/${head (attrNames (filterFiles (readDir appsPath)))}"
                    else throw "unable to find `.desktop` entry for application [${pkg.pname}]"
                  )
              );
            };
        })
        applications);
in {
  imports = lib.flatten (lib.optional graphical ../../modules/common/graphical/home-manager.nix);
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "code-insiders";
  };

  home.packages = [
    (import
      ../../lib/scripts/rebuild-system/${
        if machine == "miki"
        then "darwin"
        else "nixos"
      }.nix {
        inherit machine pkgs;
      })
  ];

  home.homeDirectory = homedir;
  home.stateVersion = "23.05";
  home.username = "noel";
  home.file =
    {
      ".wallpapers/furry.jpg".source = ../../wallpapers/furry.jpg;
      ".icons/noel.png".source = ../../icons/noel.png;
    }
    // (buildAutoStartFiles (with pkgs; [
      (discord-canary.override {
        withVencord = true;
      })

      telegram-desktop
      firefox
      spotify
    ]));

  home.shellAliases = {
    grep = "rg";
    cat = "bat -p";
    ls = "eza -l -S -F -a";
    dc = "docker compose";
    tf = "terraform";
  };

  # allow home-manager to handle itself
  programs.home-manager.enable = true;

  # gpg stuff
  programs.gpg.enable = true;

  # oh my zsh stuff
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      plugins = [
        "terraform"
        "redis-cli"
        "postgres"
        "minikube"
        "kubectl"
        "gradle"
        "bazel"
        "docker"
        "helm"
        "rust"
        "git"
        "gh"
      ];

      enable = true;
      theme = "af-magic";
      extraConfig = ''
        zstyle ':omz:update' mode reminder
        zstyle ':omz:update' frequency 30

        # [docker] enable option stacking
        zstyle ':completion:*:*:docker-*:*' option-stacking yes
        zstyle ':completion:*:*:docker:*' option-stacking yes

        # add direnv hook
        eval "$(direnv hook zsh)"
      '';
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Noel";
    userEmail = "cutie@floofy.dev";
    lfs.enable = true;
    extraConfig = {
      user.signingkey = "63182D5FE7A237C9";
      init.defaultBranch = "master";
      pull.rebase = true; # i am getting better at this :>
      safe.directory = "*"; # i don't care, even though i probably should
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      includeIf."gitdir:/Workspaces/Noelware/Internal/".path = "/Workspaces/Noelware/.gitconfig";
      includeIf."gitdir:/Workspaces/Noel/Internal/".path = "/Workspaces/Noel/.gitconfig";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      # workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      git_protocol = "ssh";
      editor = "${pkgs.nano}/bin/nano"; # use `nano` for the editor
    };

    extensions = with pkgs; [
      gh-actions-cache
    ];
  };

  programs.eza = {
    enable = true;
    git = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  dconf = {
    enable = machine != "miki";
    settings = {
      "org/gnome/desktop/screensaver" = {
        picture-uri =
          if machine == "floofbox"
          then "file://${../../wallpapers/furry.jpg}"
          else "file://${../../wallpapers/zzz.png}";
      };

      "org/gnome/desktop/background" = {
        picture-uri =
          if machine == "floofbox"
          then "file://${../../wallpapers/furry.jpg}"
          else "file://${../../wallpapers/zzz.png}";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Adwaita";
        accent-color = "pink";
        show-battery-percentage = machine == "kotoha";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = machine == "kotoha";
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = machine == "kotoha";
      };

      "org/gnome/shell" = {
        last-selected-power-profile = "performance";
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.dash-to-dock.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid

          "docker@stickman_0x00.com"
          "status-icons@gnome-shell-extensions.gcampax.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
        ];

        favorite-apps = [
          "firefox.desktop"
          "discord-canary.desktop"
          "code-insiders.desktop"
          "spotify.desktop"
          "org.gnome.Nautilus.desktop"
          "org.telegram.desktop.desktop"
          "slack.desktop"
          "com.mitchellh.ghostty.desktop"
          "thunderbird.desktop"
        ];
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-download = false;
        show-upload = false;
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-schedule-automatic = false;
        night-light-enabled = true;
        night-light-temperature = 3500;
      };
    };
  };
}
