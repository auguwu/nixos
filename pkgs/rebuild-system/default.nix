{
  stdenv,
  git,
  writeShellApplication,
  nh,
  machine,
}: let
  location =
    if stdenv.isLinux
    then "/etc/nixos"
    else "/etc/nix-darwin";

  subcmd =
    if stdenv.isLinux
    then "os"
    else "darwin";
in
  writeShellApplication {
    name = "rebuild-system";
    runtimeInputs = [git nh];
    bashOptions = [];

    text = ''
      # pull for new changes, if any
      (cd ${location} && git pull origin master || true) 2>/dev/null

      # rebuild using `nh`
      nh ${subcmd} switch ${location}#${machine} --diff always -L --accept-flake-config --no-update-lock-file
    '';
  }
