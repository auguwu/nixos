# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
_: {
  imports = [
    ../../modules/bootloader/limine.nix

    ../../modules/dev/software.nix

    ../../modules/graphical/display/kde.nix

    ../../modules/linux/networking.nix
    ../../modules/linux/graphics.nix
    ../../modules/linux/kernel.nix
    ../../modules/linux/sound.nix

    ../../modules/nix/nixos.nix

    ../../modules/virtualization/docker.nix

    ../../modules/software.nix
    ../../modules/locale.nix
    ../../modules/fonts.nix
    ../../modules/shell.nix
    ../../modules/i18n.nix

    ../../services/openssh.nix

    ./hardware.nix
  ];

  services = {
    fwupd.enable = true; # Enable `fwupd` service for BIOS updates
    fprintd.enable = true; # fingerprint scanner
    blueman.enable = true; # bluetooth
  };

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
