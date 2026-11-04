{
  pkgs,
  machine,
  lib,
  ...
}:
lib.mkIf (machine != "yuzu")
{
  home.packages = with pkgs; [
    (discord-canary.override {
      withVencord = true;
    })

    # plane-desktop
    # cattle
    # seoul

    telegram-desktop
    firefox
    spotify
    slack
  ];
}
