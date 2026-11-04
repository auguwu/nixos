{
  config,
  lib,
  ...
}: let
  inherit (config.noel.hosts.dva.networking) lanInterface gateway address domain devices;
  ip = builtins.head (lib.splitString "/" address);
in {
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    openFirewallWebserver = true;

    # https://docs.pi-hole.net/ftldns/configfile/
    settings = {
      dns = {
        upstreams = ["127.0.0.1#5335"]; # handled by `unbound.nix`
        interface = lanInterface;
        listeningMode = "LOCAL";
        domainNeeded = true;
        bogusPriv = true;
        expandHosts = true;
        domain = {
          name = domain;
          local = true;
        };

        hosts =
          [
            "${ip} dva.${domain} dva"
          ]
          ++ lib.mapAttrsToList (name: dev: "${dev.ip} ${name}.${domain} ${name}") devices;
      };

      dhcp = {
        active = true;
        start = "10.0.0.100";
        end = "10.0.0.250";
        router = gateway;
        netmask = "255.255.255.0";
        leaseTime = "24h";
        rapidCommit = true;
        ipv6 = true; # Sends RAs advertising D.Va as the IPv6 DNS server (RDNSS).
        hosts = lib.mapAttrsToList (name: dev: "${dev.mac},${dev.ip},${name}") devices;
      };

      misc.privacyLevel = 0;
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "StevenBlack's unified host list";
      }
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Pro";
      }
    ];
  };

  services.pihole-web = {
    hostName = "dva.${domain}";
    enable = true;
    ports = ["80r" "443s"];
  };

  systemd.tmpfiles.rules = [
    "f /etc/pihole/versions 0644 pihole pihole - -"
  ];
}
