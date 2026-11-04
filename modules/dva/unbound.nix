# A local recursive resolver
_: {
  services.unbound = {
    enable = true;
    resolveLocalQueries = false; # Pi-hole owns the DNS port (127.0.0.1:53)
    enableRootTrustAnchor = true;

    settings.server = {
      interface = ["127.0.0.1" "::1"];
      port = 5335;
      access-control = [
        "127.0.0.1/8 allow"
        "::1/128 allow"
      ];

      do-ip4 = true;
      do-ip6 = true;
      do-udp = true;
      do-tcp = true;

      harden-glue = true;
      harden-dnssec-stripped = true;
      use-caps-for-id = false;
      edns-buffer-size = 1232;
      prefetch = true;
      num-threads = 1;
      so-rcvbuf = "1m";

      # Drop upstream answers pointing into private ranges (DNS rebinding).
      private-address = [
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "169.254.0.0/16"
        "fd00::/8"
        "fe80::/10"
      ];
    };
  };
}
