{pkgs, ...}: {
  programs.gh = {
    enable = true;
    settings = {
      # workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      git_protocol = "ssh";
      editor = "${pkgs.nano}/bin/nano";
    };

    extensions = with pkgs; [
      gh-actions-cache
    ];
  };
}
