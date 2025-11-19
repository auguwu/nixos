# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{pkgs, ...}: {
  imports = [
    ../../modules/virtualisation/libvirt.nix
    ../../modules/virtualisation/docker.nix
    ../../modules/common/graphical

    ../../modules/common/nixos.nix
    ../../modules/common

    ./hardware.nix
  ];

  boot = {
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        secureBoot = {
          enable = true;
          sbctl = pkgs.sbctl;
        };

        # This will add a entry to Limine that lets me go into my Windows
        # installation whenever I please.
        extraConfig = ''
          /Windows
            protocol: efi
            path: uuid(6af6f736-4c9a-4f6a-a624-0618824fca25):/EFI/Microsoft/Boot/bootmgfw.efi
        '';

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
  systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

  # networking stuff
  networking = {
    hostName = "floofbox";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
  };

  # external services only allowed on `floofbox`
  services.dnsmasq.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      TcpKeepAlive = true;
      KbdInteractiveAuthentication = false;
    };
  };

  # graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [mesa];
  };

  # make sure that Discord voice works and this is I know how it would work
  programs.noisetorch.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#System_time
  time.hardwareClockInLocalTime = true;

  # secrets!
  #  sops = {
  #    age.keyFile = "/home/noel/.config/sops/age/keys.txt";
  #    defaultSopsFile = ../../secrets.yaml;
  #  };

  # extra packages that only noel@floofbox should install
  environment.systemPackages = [
    pkgs.sbctl
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
