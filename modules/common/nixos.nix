{pkgs, ...}: {
  # Set our default locale, which is English (UK) even though
  # I live in the states but whatever?
  i18n.defaultLocale = "en_GB.UTF-8";

  fonts.fontDir.enable = true;

  # Configure `nix` itself.
  nix = {
    # Prefer the stable version of Nix
    package = pkgs.nixVersions.stable;

    # Optimise /nix automatically per build
    optimise.automatic = true;

    # Set garbage collection to run weekly
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      # Allow the "experimental" flakes command to be allowed.
      experimental-features = "nix-command flakes";
      trusted-users = ["noel"];

      # A list of trusted binary caches that we will use for Nix packages.
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://noel.cachix.org" # TODO: move to nix.floofy.dev
        "https://noelware.cachix.org" # TODO: move to nix.noelware.org
      ];

      # List of public keys used to sign binary caches.
      trusted-public-keys = [
        "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
        "noelware.cachix.org-1:22A8ELRjkqEycSHz+R5A5ReX2jyjU3rftsBmlD6thn0="
      ];

      substituters = [
        "https://noel.cachix.org"
        "https://noelware.cachix.org"
      ];
    };
  };

  # use zsh as our shell
  environment.shells = [pkgs.zsh];

  # configure zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      grep = "rg";
      cat = "bat -p";
      ls = "eza -l -S -F -a";
      dc = "docker compose";
      tf = "terraform";
    };
  };

  # disable pulseaudio
  services.pulseaudio.enable = false;

  # sound (PipeWire)
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  services = {
    xserver.xkb.layout = "us";
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.dconf.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      fuse3
      glibc
      curl
      zlib
      icu
      nss
    ];
  };

  environment.systemPackages = with pkgs; [
    sops

    # KDE-related
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.ksystemlog
    kdePackages.sddm-kcm

    # other utils
    hardinfo2
    vlc
    wayland-utils
    wl-clipboard
  ];
}
