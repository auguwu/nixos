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

    # Language Servers
    tofu-ls
    starpls
    nil
  ];
}
