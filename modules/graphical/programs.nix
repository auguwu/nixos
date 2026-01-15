{pkgs, ...}: {
  home.packages = with pkgs; [
    (discord-canary.override {
      withVencord = true;
    })

    # youtrack-desktop
    # cattle
    # seoul

    telegram-desktop
    spotify
    slack
  ];
}
