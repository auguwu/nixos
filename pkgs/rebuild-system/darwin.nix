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
    (cd /etc/nix-darwin && git pull origin master) 2>/dev/null

    # TODO(@auguwu): rebuild system here
  '';
}
