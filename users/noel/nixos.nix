{
  config,
  pkgs,
  lib,
  ...
}: let
  mkGroups = let
    inherit (lib) flatten concatMap optional head tail;
  in
    groups: flatten (concatMap (value: optional (head value) (tail value)) groups);
in {
  users.users.noel = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups =
      mkGroups [
        # [config.virtualisation.noelware.eous.enable "eousd"]
        [config.networking.networkmanager.enable "networkingmanager"]
        [config.virtualisation.docker.enable "docker"]
        [config.hardware.bluetooth.enable "bluetooth"]
      ]
      ++ ["wheel"];

    openssh.authorizedKeys.keys = [
      # Framework (noel@kotoha)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqqqAoViwgSCdS5XOoAbCfjtqeBwO4MHtkA6AknMjMQ noel@kotoha"

      # Workstation (noel@floofbox)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChkXjLXvRSIqcRh2Y/qcpSrgBw/+hF+uHK1mPiIKsWF noel@floofbox"

      # Mac Mini (noel@yuzu)

      # noel@hokkaido
    ];
  };
}
