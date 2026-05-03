# Edit this configuration file to define what should be installed on
# your system.  Help is avaliable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{pkgs, ...}: {
  imports = [
    ../../modules/bootloader/limine.nix

    ../../modules/dev/software.nix
    ../../modules/dev/ld.nix

    ../../modules/gaming/steam.nix

    ../../modules/graphical/display/kde.nix

    ../../modules/hokkaido/minecraft-server.nix

    ../../modules/linux/cloudflared.nix
    ../../modules/linux/networking.nix
    ../../modules/linux/graphics.nix
    ../../modules/linux/kernel.nix
    ../../modules/linux/sound.nix
    ../../modules/linux/shell.nix

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

  boot.loader.limine = {
    secureBoot = {
      enable = true;
      sbctl = pkgs.sbctl;
    };

    extraConfig = ''
      /Windows
        protocol: efi
        path: uuid(6af6f736-4c9a-4f6a-a624-0618824fca25):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  programs.noisetorch.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#System_time
  time.hardwareClockInLocalTime = true;

  # Fix uv python ssl.SSLCertVerificationError
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };

  environment.systemPackages = with pkgs; [
    sbctl
    qemu
  ];

  services.flatpak.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
