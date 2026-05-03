_: {
  # disable pulseaudio
  services.pulseaudio.enable = false;

  # sound (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
}
