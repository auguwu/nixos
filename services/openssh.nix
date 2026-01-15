{lib, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      TcpKeepAlive = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkOverride 900 "no";
    };
  };
}
