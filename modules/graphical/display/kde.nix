_: {
  services = {
    xserver.xkb.layout = "us";
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
