{
  nixos-rebuild,
  git,
  nix-output-monitor,
  writeShellApplication,
  machine,
}:
writeShellApplication {
  name = "rebuild-system";
  runtimeInputs = [nixos-rebuild nix-output-monitor git];
  bashOptions = [];

  text = ''
    # Pull for new changes, if any.
    (cd /etc/nixos && git pull origin master) 2>/dev/null

    # Rebuild the system!
    (
      set -euo pipefail && \
        sudo nixos-rebuild switch --flake /etc/nixos#${machine} \
          --accept-flake-config \
          --show-trace \
          --log-format internal-json 2>&1 |& nom --json
    )
  '';
}
