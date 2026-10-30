{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = [];
    })

    opentofu
    direnv

    # noelctl
    # noeldoc

    # Node.js
    nodejs_latest

    # Bazel
    bazel_9
    bazel-buildtools

    # Language Servers
    tofu-ls
    starpls
    nil
  ];
}
