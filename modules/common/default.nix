# This module is common for ALL hosts.
{pkgs, ...}: {
  time.timeZone = "America/Los_Angeles";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.geist-mono

    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts

    jetbrains-mono
    inter
  ];

  programs.gnupg.agent = {
    enableSSHSupport = true;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      #plugins = [charted-helm-plugin];
    })

    minio-client
    minikube
    opentofu
    kubectl

    # lsps
    alejandra
    tofu-ls
    nil

    # other utilities
    nix-output-monitor
    ripgrep
    direnv
    netcat
    unzip
    tokei
    whois
    which
    nano
    gzip
    tree
    file
    htop
    dig
    zip
    git
    yq
    jq
    uv

    # Protobuf
    protobuf

    # Rust
    cargo-whatfeatures
    cargo-nextest
    cargo-machete
    cargo-expand
    cargo-cache
    cargo-deny
    rustup

    # Node.js
    nodejs_latest

    # Other utilties
    # noelctl
    # noeldoc

    ume
  ];
}
