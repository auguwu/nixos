{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ghostty
      else pkgs.ghostty-bin;

    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrains Mono";
      theme = "Iceberg Dark";
      font-size = 15;
      background-image = "${../../wallpapers/littlearrowdog.jpg}";
      background-image-opacity = 0.025;
      background-image-fit = "cover";
      selection-foreground = "#d961a3";
      async-backend = "io_uring";
      auto-update = "off";
    };
  };
}
