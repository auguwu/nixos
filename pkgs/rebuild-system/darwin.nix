{
  darwin-rebuild,
  git,
  writeShellApplication,
  machine,
}:
writeShellApplication {
  name = "rebuild-system";
  runtimeInputs = [darwin-rebuild git];
  bashOptions = [];

  text = ''
    # Pull for new changes, if any.
    (cd /etc/nix-darwin && git pull origin master || true) 2>/dev/null

    # Rebuild the system!
    sudo darwin-rebuild switch --flake /etc/nix-darwin#${machine} --show-trace
  '';
}
