{
  lib,
  config,
  ...
}: let
  cfg = config.noel.hosts.dva.networking;
in {
  options.noel.hosts.dva.networking = {
    lanInterface = lib.mkOption {
      type = lib.types.str;
      default = "enp1s0";
      description = "LAN interface that Pi-host listens and serves DHCP on";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.2/24";
      description = "Static address (CIDR) for `dva`";
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1";
      description = "default gateway, also handed out as the DHCP router";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "noel";
      description = "Local DNS suffix. devices will resolve as `<name>.<domain>`";
    };

    devices = lib.mkOption {
      description = ''
        Devices that always get the same IPv4 address from Pi-host's DHCP server and
        are resolved as `<name>.<domain>`. Keep the IPs outside the dynamic pool (10.0.0.{100~250}
        by default).
      '';

      default = {};
      example = {
        floofbox = {
          mac = "aa:bb:cc:dd:ee:ff";
          ip = "10.0.0.10";
        };
      };

      type = lib.types.attrsOf (lib.types.submodule {
        mac = lib.mkOption {
          type = lib.types.strMatching "([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}";
          description = "Hardware address of the device's LAN interface.";
        };
        ip = lib.mkOption {
          type = lib.types.str;
          description = "Fixed IPv4 address to hand out.";
        };
      });
    };
  };

  config = {
    assertions = let
      devices = lib.attrValues cfg.devices;
      dupes = xs: lib.length xs != lib.length (lib.unique xs);
    in [
      {
        assertion = !dupes (map (d: d.ip) devices);
        message = "`noel.hosts.dva.networking`: two devices share the same IP";
      }

      {
        assertion = !dupes (map (d: d.mac) devices);
        message = "`noel.hosts.dva.networking`: two devices share the same MAC address";
      }
    ];

    networking = {
      hostName = "dva";
      useDHCP = false;
      useNetworkd = true;
      firewall.enable = true;
      nameservers = [
        "127.0.0.1"
      ];
    };

    services.resolved.enable = true;
    systemd.network = {
      enable = true;
      networks."10-lan" = {
        matchConfig.Name = cfg.lanInterface;
        address = [cfg.address];
        routes = [
          {
            Gateway = cfg.gateway;
          }
        ];

        networkConfig = {
          # Take a SLAAC address from Comcast's prefix so Pi-hole has a global
          # v6 address to advertise as RDNSS.
          IPv6AcceptRA = true;
          LinkLocalAddressing = "ipv6";
        };

        ipv6AcceptRAConfig.UseDNS = false;
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
