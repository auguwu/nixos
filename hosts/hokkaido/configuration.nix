# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
_: {
  imports = [
    ../../modules/bootloader/limine.nix

    ../../modules/linux/networking.nix
    ../../modules/linux/kernel.nix

    ../../modules/nix/nixos.nix

    ../../modules/virtualization/docker.nix

    ../../modules/software.nix
    ../../modules/locale.nix
    ../../modules/shell.nix

    ../../services/openssh.nix

    ./hardware.nix
  ];
}
