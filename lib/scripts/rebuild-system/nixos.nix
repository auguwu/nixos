{
  machine,
  pkgs,
}: let
  inherit
    (pkgs)
    nixos-rebuild
    git
    nix-output-monitor
    writeShellApplication
    ;
in
  writeShellApplication {
    name = "rebuild-system";
    runtimeInputs = [nixos-rebuild git nix-output-monitor];

    # We intentionally remove `pipefail` since `git pull` can fail
    # but we don't need it to succeed everytime.
    bashOptions = [];

    text = ''
      (cd /etc/nixos && git pull origin master) 2>/dev/null
      (set -euo pipefail && sudo nixos-rebuild switch --flake /etc/nixos#${machine} --accept-flake-config \
        --show-trace \
        --log-format internal-json 2>&1 |& nom --json)
    '';
  }
