{
  nixpkgs,
  pkgs,
  machine,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

    ../../modules/linux/networking.nix
    ../../modules/linux/kernel.nix
    ../../modules/linux/shell.nix

    ../../modules/nix/nixos.nix

    ../../modules/locale.nix
    ../../modules/shell.nix
    ../../modules/i18n.nix
  ];

  boot.supportedFilesystems = nixpkgs.lib.mkForce ["btrfs" "ext4" "vfat" "ntfs" "xfs"];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../../pkgs/rebuild-system/nixos.nix {inherit machine;})

    nix-output-monitor
    ripgrep
    unzip
    whois
    which
    nano
    gzip
    tree
    file
    git
    duf
    dig
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      TcpKeepAlive = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  users.users.root.initialPassword = "nixos";
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "nixos";
  };
}
