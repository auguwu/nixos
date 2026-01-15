_: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;

      # Only 2 generations are present so that you can boot into
      # the latest one and the previous one in case the latest
      # breaks.
      maxGenerations = 2;
      style = {
        wallpaperStyle = "centered";
        interface.brandingColor = 5; # Magenta
        wallpapers = [
          ../../wallpapers/littlearrowdog.jpg
        ];
      };
    };
  };
}
