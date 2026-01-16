_: {
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;

    shellAliases = {
      grep = "rg";
      cat = "bat -p";
      ls = "eza -l -S -F -a";
    };
  };
}
