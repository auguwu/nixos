_: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;

      # Only the last 4 + current generation are present so that you can boot into
      # the latest one and the previous one in case the latest
      # breaks.
      maxGenerations = 5;
      style = {
        wallpaperStyle = "centered";
        interface.brandingColor = "#f4b5d5"; # Magenta
        wallpapers = [
          ../../wallpapers/littlearrowdog.jpg
        ];
      };
    };
  };
}
