{
  networking.firewall = {
    allowedUDPPorts = [51820];
  };

  networking.wg-quick.interfaces = {
    kube0 = {
      address = ["192.168.1.2/24"];
      privateKeyFile = "/home/noel/.wg/noelware/privatekey";
      peers = [
        {
          publicKey = "GBI4hO6hPaOteqqONSvwF+fKAjJ5zhB8/dPPd+dr/DE=";
          allowedIPs = [
            "192.168.254.0/24"
          ];

          endpoint = "104.238.221.168:58025";
        }
      ];
    };
  };
}
