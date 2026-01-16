{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      fuse3
      glibc
      curl
      zlib
      icu
      nss
    ];
  };
}
