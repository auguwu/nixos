{
  pkgs,
  machine,
  ...
}:
if machine != "yuzu"
then {
  home.packages = with pkgs; [
    (discord-canary.override {
      withVencord = true;
    })

    # youtrack-desktop
    # cattle
    # seoul

    telegram-desktop
    firefox
    spotify
    slack
  ];
}
else {}
