# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{pkgs, ...}: {
  imports = [
    ../../modules/virtualisation/docker.nix
    ../../modules/common/graphical

    ../../modules/common/nixos.nix
    ../../modules/common

    ./hardware.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        maxGenerations = 2; # only allow a single generation to be present plus a backup in case
        style = {
          wallpaperStyle = "centered";
          interface.brandingColor = 5; # Magenta
          wallpapers = [
            ../../wallpapers/littlearrowdog.jpg
          ];
        };
      };
    };
  };

  # use latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking stuff
  networking = {
    hostName = "kotoha";
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    networkmanager.enable = true;
  };

  # Enable fwupd service since BIOS updates are through
  # LVFS.
  services.fwupd.enable = true;

  # Enable this for fingerprint scanner
  services.fprintd.enable = true;

  # enable OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      TcpKeepAlive = true;
      KbdInteractiveAuthentication = false;
    };
  };

  # Graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [mesa.drivers];
  };

  # Enable Bluetooth capabilities
  # `kotoha` is the only machine (except `miki`) that has bluetooth
  # avaliable.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
