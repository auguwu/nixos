{
  config,
  pkgs,
  lib,
  ...
}: let
  mkGroups = with lib; groups: flatten (concatMap (value: optional (head value) (tail value)) groups);
in {
  users.users.noel = {
    isNormalUser = true;
    extraGroups =
      mkGroups [
        [config.networking.networkmanager.enable "networkmanager"]
        [config.virtualisation.docker.enable "docker"]
        [config.virtualisation.libvirtd.enable "libvirtd"]
        [config.hardware.bluetooth.enable "bluetooth"]
      ]
      ++ ["wheel"];

    openssh.authorizedKeys.keys = [
      # Framework (noel@kotoha)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqqqAoViwgSCdS5XOoAbCfjtqeBwO4MHtkA6AknMjMQ noel@kotoha"

      # Workstation (noel@floofbox)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChkXjLXvRSIqcRh2Y/qcpSrgBw/+hF+uHK1mPiIKsWF noel@floofbox"

      # Mac Mini (noel@yuzu)
    ];

    shell = pkgs.zsh;
  };
}
