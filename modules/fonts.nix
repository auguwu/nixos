{
  machine,
  pkgs,
  lib,
  ...
}: {
  fonts = {
    fontDir = lib.mkIf (machine != "yuzu") {
      enable = true;
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.geist-mono

      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      noto-fonts

      jetbrains-mono
      inter
    ];
  };
}
