{
  machine,
  lib,
  inputs,
  ...
}: {
  programs.draconisplusplus = {
    enable = machine != "yuzu";
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
