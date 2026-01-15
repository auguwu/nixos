{
  pkgs,
  lib,
  machine,
  ...
}: let
  baseSettingsContent =
    builtins.replaceStrings [
      "@clang-tools@"
      "@powershell@"
      "@tofu-ls@"
      "@tofu@"
      "@helm@"
      "@nil@"
      "@nix@"
    ] [
      "${pkgs.clang-tools}"
      "${pkgs.powershell}"
      "${pkgs.tofu-ls}"
      "${pkgs.opentofu}"
      "${pkgs.helm}"
      "${pkgs.nil}"
      "${pkgs.nixVersions.stable}"
    ] (builtins.readFile ./vscode/userSettings.json);

  baseSettings = builtins.fromJSON (builtins.unsafeDiscardStringContext baseSettingsContent);
  machineSettings =
    if builtins.pathExists ./vscode/userSettings.${machine}.json
    then builtins.fromJSON (builtins.readFile ./vscode/userSettings.${machine}.json)
    else {};

  userSettings = lib.recursiveUpdate baseSettings machineSettings;
  extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
    astro-build.astro-vscode
    llvm-vs-code-extensions.vscode-clangd
    ms-vscode-remote.remote-containers
    jnoortheen.nix-ide
    rust-lang.rust-analyzer
    bradlc.vscode-tailwindcss
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    mkhl.direnv
    ms-azuretools.vscode-docker
    github.vscode-github-actions
    tamasfe.even-better-toml
    golang.go
    hashicorp.terraform
    ms-kubernetes-tools.vscode-kubernetes-tools
    ms-vscode-remote.remote-ssh
    redhat.vscode-yaml
    xaver.clang-format
    skellock.just
    unifiedjs.vscode-mdx
    wakatime.vscode-wakatime
    ms-vscode.powershell
    catppuccin.catppuccin-vsc-icons
    bazelbuild.vscode-bazel
    ms-vscode.cmake-tools
    hashicorp.hcl
    github.vscode-github-actions
    yoavbls.pretty-ts-errors
    vue.volar
    opentofu.vscode-opentofu
    antfu.theme-vitesse
    ms-python.python
    ms-azuretools.vscode-docker
    ms-azuretools.vscode-containers

    # (pkgs.callPackage ../../pkgs/vscode/extensions/google.gn {})
  ];
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-insiders.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [pkgs.krb5];
    });

    profiles.default = {
      inherit userSettings extensions;
    };
  };
}
