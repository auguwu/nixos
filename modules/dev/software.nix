{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = [];
    })

    minio-client
    opentofu
    direnv

    # noelctl
    # noeldoc

    # ai in my system?! it can happen :pensive:
    claude-code

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
