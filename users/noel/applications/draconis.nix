{
  machine,
  lib,
  inputs,
  ...
}: {
  programs.draconisplusplus = {
    # currently breaks because it depends on dbus statically, which is
    # broken right now.
    enable = false; # enable = machine != "yuzu";
    configFormat = "hpp";
    username = "Noel";
    staticPlugins = ["weather" "now_playing"];
    packageManagers = ["nix"] ++ lib.optionals (machine == "yuzu") ["homebrew"];
    enablePlugins = true;
    pluginsSrc = inputs.draconis-plugins;

    pluginConfigs = {
      weather = {
        enabled = true;
        provider = "openmetro";
        city = "Oakland";
      };
    };
  };
}
