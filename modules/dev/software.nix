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

    # ai in my system?! it can happen
    claude-code

    # Bazel
    bazel_8
    bazel-buildtools

    # Language Servers
    tofu-ls
    starpls
    nil
  ];
}
