{pkgs, ...}: {
  programs.gnupg.agent = {
    enableSSHSupport = true;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # utilities
    nix-output-monitor
    ripgrep
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
    duf
    dig
    zip
    git
    yq
    jq
    nh
  ];
}
