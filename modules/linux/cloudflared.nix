{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.cloudflared
  ];

  services.cloudflared = {
    enable = true;
    tunnels = {
      # mc.noel.pink
      "6a3a2a93-e3f5-46e6-a088-a9d781b40108" = {
        # TODO(@auguwu/Noel): move these to Vault once available
        certificateFile = "/home/noel/.cloudflared/cert.pem";
        credentialsFile = "/home/noel/.cloudflared/6a3a2a93-e3f5-46e6-a088-a9d781b40108.json";
        default = "http_status:404";
        ingress."mc.noel.pink" = "tcp://localhost:25565";
      };
    };
  };
}
