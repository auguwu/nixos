{
  pkgs,
  lib,
  ...
}: {
  # The `lib.optionals` check is here because on Darwin, it pulls `musl` for some reason
  # and `musl` is not supported on Darwin. I don't really use JetBrains IDEs on Darwin
  # but I will once Bazel for C++ is supported then I'll have to debug this.
  home.packages = lib.optionals (pkgs.stdenv.isLinux) (with pkgs; [
    jetbrains.clion
    jetbrains.idea
  ]);
}
