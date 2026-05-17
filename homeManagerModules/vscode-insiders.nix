# This mimics `programs.vscode` from Home Manager but it doesn't support Insiders. To use this
# module, you'll need to use `programs.vscode-insiders` instead of `programs.vscode` to work properly.
#
# Original: https://github.com/nix-community/home-manager/blob/c909892de502b4de9e92838a503c09a9c8ebe4aa/modules/programs/vscode/default.nix
{inputs}: {
  config,
  lib,
  ...
}: let
  mkVscodeModule = import "${inputs.home-manager}/modules/programs/vscode/mkVscodeModule.nix";
in {
  imports =
    [
      (mkVscodeModule {
        modulePath = ["programs" "vscode-insiders"];
        name = "Visual Studio Code - Insiders";
        packageName = "vscode-insiders";
        nameShort = "Code - Insiders";
        dataFolderName = ".vscode-insiders";
      })

      (
        lib.mkChangedOptionModule
        [
          "programs"
          "vscode-insiders"
          "immutableExtensionsDir"
        ]
        ["programs" "vscode-insiders" "mutableExtensionsDir"]
        (config: !config.programs.vscode-insiders.immutableExtensionsDir)
      )
    ]
    ++ map
    (
      v:
        lib.mkRenamedOptionModule
        ["programs" "vscode-insiders" v]
        [
          "programs"
          "vscode-insiders"
          "profiles"
          "default"
          v
        ]
    )
    [
      "enableUpdateCheck"
      "enableExtensionUpdateCheck"
      "userSettings"
      "userTasks"
      "userMcp"
      "keybindings"
      "extensions"
      "languageSnippets"
      "globalSnippets"
    ];
}
