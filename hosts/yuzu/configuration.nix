{
  pkgs,
  machine,
  ...
}: {
  imports = [
    ../../modules/dev/software.nix

    ../../modules/nix/darwin.nix

    ../../modules/software.nix
    ../../modules/locale.nix
    ../../modules/fonts.nix
    ../../modules/shell.nix
  ];

  networking = {
    hostName = machine;
    computerName = "Noel's Mac Mini";
  };

  # For some reason, home.packages won't install the software I need, so
  # this is being used here instead of `modules/graphical/programs.nix`
  environment.systemPackages = with pkgs; [
    # youtrack-desktop
    # cattle
    # seoul

    telegram-desktop
    firefox
    spotify
    raycast
    slack
  ];

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
    };

    # nixpkgs for the software on Darwin is kinda
    # fucked in a way, so we'll use Homebrew for now.
    casks = [
      "discord@canary"
      "ghostty"
    ];
  };

  system.primaryUser = "noel";

  # The value is used to backwards‐incompatible changes in default settings.
  # You should usually set this once when installing nix-darwin on a new system
  # and then never change it (at least without reading all the relevant
  # entries in the changelog using `darwin-rebuild changelog`).
  system.stateVersion = 5;
}
