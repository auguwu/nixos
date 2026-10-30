{pkgs, ...}: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "${pkgs.nano}/bin/nano";
    };

    extensions = with pkgs; [gh-webhook];
  };
}
