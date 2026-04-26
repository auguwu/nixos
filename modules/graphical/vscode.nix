{
  pkgs,
  lib,
  machine,
  ...
}: let
  baseSettings = builtins.fromJSON (builtins.readFile ./vscode/userSettings.json);
  machineSettings =
    if builtins.pathExists ./vscode/userSettings.${machine}.json
    then builtins.fromJSON (builtins.readFile ./vscode/userSettings.${machine}.json)
    else {};

  userSettings = lib.recursiveUpdate baseSettings machineSettings;
  extensions = with pkgs.nix-vscode-extensions.vscode-marketplace;
    [
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
      anthropic.claude-code
      drblury.protobuf-vsc
      mesonbuild.mesonbuild
    ]
    ++ (with pkgs.nix-vscode-extensions.vscode-marketplace-universal; [
      vadimcn.vscode-lldb
    ]);
in {
  home.packages = with pkgs; [
    # A list of LSPs that should be used
    starpls
    mesonlsp

    # Used for the Protobuf VSCode extension
    protobuf
    grpcurl
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-insiders.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [pkgs.krb5];
    });

    profiles.default = {
      inherit extensions;

      userSettings =
        {
          "powershell.powerShellDefaultVersion" = "Nixpkgs";
          "powershell.powerShellAdditionalExePaths" = {
            "Nixpkgs" = "${pkgs.powershell}/bin/pwsh";
          };

          "mesonbuild.selectRootDir" = false;
          "mesonbuild.configureOnOpen" = true;
          "mesonbuild.mesonPath" = "${pkgs.meson}/bin/meson";
          "mesonbuild.languageServerPath" = "${pkgs.mesonlsp}/bin/mesonlsp";
          "mesonbuild.downloadLanguageServer" = false;
          "mesonbuild.modifySettings" = false;
        }
        // userSettings;
    };
  };
}
