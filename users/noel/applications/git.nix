{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;

    settings = {
      user.email = "cutie@floofy.dev";
      user.name = "Noel Towa";
      user.signingkey = "9122EB12C815DEA3";
      init.defaultBranch = "master";
      pull.rebase = true;
      safe.directory = "*"; # i don't care
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      credential.helper = "libsecret";
    };
  };
}
