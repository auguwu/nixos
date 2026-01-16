{machine, ...}: {
  programs.ghostty = {
    enable = machine != "yuzu"; # Ghostty on macOS is pretty broken, the Homebrew version is used instead
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrains Mono";
      theme = "Material Darker";
      font-size = 14;
      background-image = "${../../wallpapers/littlearrowdog.jpg}";
      background-image-opacity = 0.025;
      background-image-fit = "cover";
      selection-foreground = "#d961a3";
      async-backend = "io_uring";
      auto-update = "off";
    };
  };
}
