{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
      experimental = true;
    };
  };

  environment.systemPackages = [
    (pkgs.docker.override {
      composeSupport = true; # installs and enables Docker Compose v2
      buildxSupport = true; # uses buildx for building images
    })
  ];
}
