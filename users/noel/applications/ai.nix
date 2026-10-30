{
  pkgs,
  lib,
  ...
}: {
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      includeCoAuthoredBy = false;
      remoteControlAtStartup = false;
      permissions.allow = [
        "WebSearch"
        "WebFetch"
        "Read(/nix/store/**)"
      ];
    };

    skills = {
      i-have-adhd = "${pkgs.fetchFromGitHub {
        owner = "ayghri";
        repo = "i-have-adhd";
        rev = "24d22f783e57cb73c957848b588c6f651b6f9cd8";
        hash = "sha256-xTVs8SFhJEil8yjx3ODB7Gn3h1rg4QSq4zHPncWvV3c=";
      }}/skills/i-have-adhd";
    };
  };

  programs.mcp = {
    enable = true;
    servers = {
      nixos = {
        command = lib.getExe pkgs.mcp-nixos;
      };
    };
  };
}
