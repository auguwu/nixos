{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.clion
  ];
}
