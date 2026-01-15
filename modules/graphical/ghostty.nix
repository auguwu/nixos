_: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrains Mono";
      theme = "Material Darker";
      font-size = 14;
      background-image = "${../../wallpapers/littlearrowdog.jpg}";
      background-image-opacity = 0.125;
      background-image-fit = "cover";
      selection-foreground = "#d961a3";
      async-backend = "io_uring";
      auto-update = "off";
    };
  };
}
