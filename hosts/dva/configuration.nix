# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{lib, ...}: {
  imports = [
    ../../modules/bootloader/limine.nix

    ../../modules/dva/networking.nix
    ../../modules/dva/unbound.nix
    ../../modules/dva/pihole.nix

    ../../modules/linux/kernel.nix
    ../../modules/linux/shell.nix

    ../../modules/nix/nixos.nix

    ../../modules/locale.nix
    ../../modules/shell.nix
    ../../modules/i18n.nix

    ../../services/openssh.nix

    ./hardware.nix
  ];

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096; # 4GiB
      cores = 2;
      graphics = false;
      forwardPorts = [
        {
          from = "host";
          proto = "udp";
          host.port = 1053;
          guest.port = 53;
        }

        {
          from = "host";
          proto = "tcp";
          host.port = 1053;
          guest.port = 53;
        }

        {
          from = "host";
          proto = "tcp";
          host.port = 8080;
          guest.port = 80;
        }

        {
          from = "host";
          proto = "tcp";
          host.port = 8443;
          guest.port = 443;
        }

        {
          from = "host";
          proto = "tcp";
          host.port = 2222;
          guest.port = 22;
        }
      ];
    };

    noel.hosts.dva.networking = {
      lanInterface = "eth0";
      address = "10.0.2.15/24";
      gateway = "10.0.2.2";
    };

    services.pihole-ftl.settings = {
      dhcp.active = lib.mkForce false;
      misc.readOnly = false;
    };

    services.pihole-web.ports = lib.mkForce ["80" "443s"];
    users.users.noel.initialPassword = "noel";
  };

  noel.hosts.dva.networking = {
    # lanInterface = "eth0";
    # address = "10.0.2.15/24";
    # gateway = "10.0.2.2";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.11"; # Did you read the comment?
}
