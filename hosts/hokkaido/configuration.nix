# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{lib, ...}: {
  imports = [
    ../../modules/bootloader/limine.nix

    ../../modules/hokkaido/minecraft-server.nix
    ../../modules/hokkaido/hashicorp-vault.nix

    ../../modules/linux/networking.nix
    ../../modules/linux/kernel.nix
    ../../modules/linux/shell.nix

    ../../modules/nix/nixos.nix

    ../../modules/virtualization/docker.nix

    ../../modules/software.nix
    ../../modules/locale.nix
    ../../modules/shell.nix

    ../../services/openssh.nix

    ./hardware.nix
  ];

  # This is used to test `noel@hokkaido` locally without doing messy work
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 16382; # 16GiB
      cores = 4; # 4 cores
      diskSize = 120000; # 120GiB
      graphics = false;
      forwardPorts = [
        # allows `ssh noel@localhost -p 2221`
        {
          from = "host";
          host.port = 2221;
          guest.port = 22;
        }
      ];
    };

    users.users.noel.initialPassword = "noel";
    services.vault = {
      dev = true;
      storageBackend = lib.mkForce "inmem";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
