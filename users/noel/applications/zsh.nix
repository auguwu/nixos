_: {
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      plugins = [
        "terraform"
        "redis-cli"
        "postgres"
        "minikube"
        "kubectl"
        "gradle"
        "bazel"
        "docker"
        "helm"
        "rust"
        "git"
        "gh"
      ];

      extraConfig = ''
        zstyle ':omz:update' mode reminder
        zstyle ':omz:update' frequency 30

        # [docker] enable option stacking
        zstyle ':completion:*:*:docker-*:*' option-stacking yes
        zstyle ':completion:*:*:docker:*' option-stacking yes

        # add direnv hook
        if command -v direnv >/dev/null; then
          eval "$(direnv hook zsh)"
        fi
      '';
    };
  };
}
