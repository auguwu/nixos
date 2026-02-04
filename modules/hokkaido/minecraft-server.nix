{pkgs, ...}: let
  mods = builtins.fromJSON (builtins.readFile ./minecraft/mods.json);
  loaderVersion = "0.18.4";
in {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.gamblecore = {
      enable = true;
      autoStart = true;
      package = pkgs.fabricServers.fabric-1_21_11.override {
        inherit loaderVersion;
      };

      whitelist = {
        Polarboi_ = "6775b2a2-322d-411f-a397-afe1ba1983ac";
        Burner_J = "9664354a-2399-4aa5-9071-a81f7838f158";
        Night_Runner117 = "c6ba4d70-c4f4-442d-b1e6-7157b0a139c5";
        ActuallyPanda = "9fe6e426-8dca-42ef-826d-abfd51330041";
        Baygull = "b9cd77b3-e380-4569-81ac-7032ddf0804b";
        JoeyJac1234 = "851a672f-8ee2-49a1-aeb6-ca33ec028255";
      };

      operators = {
        Burner_J = "9664354a-2399-4aa5-9071-a81f7838f158";
        Polarboi_ = {
          uuid = "6775b2a2-322d-411f-a397-afe1ba1983ac";
          level = 3;
        };
      };

      jvmOpts = "-Xms2048M -Xmx8192M";
      serverProperties = {
        server-port = 25565;
        difficulty = 2;
        gamemode = 0;
        max-players = 10;
        white-list = true;
        allow-cheats = false;
        level-seed = "5305058588807706282";
      };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (map (attr:
          pkgs.fetchurl {
            inherit (attr) url;
            sha256 = attr.hash;
          })
        mods);
      };
    };
  };
}
