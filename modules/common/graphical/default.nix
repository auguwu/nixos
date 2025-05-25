{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    gnome-screenshot # since I use GNOME and Flameshot keeps fucking up with `ume screenshot`
    telegram-desktop
    (discord-canary.override {
      withVencord = true;
    })

    # IDEs
    jetbrains.idea-community

    thunderbird # TODO(@noel): switch to Seoul once I finish it
    spotify
    slack

    # cattle
    # seoul
  ];
}
