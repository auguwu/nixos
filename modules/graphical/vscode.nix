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
    anthropic.claude-code

    # polarboi.zenful or zenful.editors.vscode
  ];
  # fails because of:
  #
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>   File "/nix/store/73mwy44y8qkwnczcpj64xfrcmv1vgl8i-python3-3.13.11-env/lib/python3.13/subprocess.py", line 1039, in __init__
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>     self._execute_child(args, executable, preexec_fn, close_fds,
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>     ~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         pass_fds, cwd, env,
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         ^^^^^^^^^^^^^^^^^^^
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>     ...<5 lines>...
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         gid, gids, uid, umask,
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         ^^^^^^^^^^^^^^^^^^^^^^
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         start_new_session, process_group)
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>   File "/nix/store/73mwy44y8qkwnczcpj64xfrcmv1vgl8i-python3-3.13.11-env/lib/python3.13/subprocess.py", line 1991, in _execute_child
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging>     raise child_exception_type(errno_num, err_msg, err_filename)
  # vscode-lldb-codelldb-types-1.12.1-vendor-staging> FileNotFoundError: [Errno 2] No such file or directory: 'nix-prefetch-git'
  #
  # ++ (with pkgs.nix-vscode-extensions.vscode-marketplace-universal; [
  #   vadimcn.vscode-lldb
  # ]);
in {
  home.packages = [
    # A list of LSPs that should be used
    pkgs.starpls
    # pkgs.zenful
  ];

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
