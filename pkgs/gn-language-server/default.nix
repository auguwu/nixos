{
  rustPlatform,
  fetchFromGitHub,
  python3,
  git,
  lib,
  fetchgit,
}: let
  gn-src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "9673115bc14c8630da5b7f6fe07e0b362ac49dcb";
    sha256 = "sha256-JXsoHD4gpeiK9cSwa3KCh/2xG/q4i03NJzfmwi9f98s=";
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "gn-language-server";
    version = "1.11.6";
    src = fetchFromGitHub {
      owner = "google";
      repo = "gn-language-server";
      rev = "v${version}";
      sha256 = "sha256-aB2oMFYls+e8xBySIlEbJ2HDmJVkuMAtkIU14iy0tDs=";
    };

    cargoHash = "sha256-xLJopSiD385kJ9b34o+9wroAsch8biPumS/XKKpSsKc=";

    nativeBuildInputs = [
      python3
      gn-src
      git
    ];

    patches = [
      ./patches/001_gen_script.patch
    ];

    buildPhase = ''
      export NIX_GN_SRC=${gn-src}
      export CARGO_TARGET_DIR=$PWD/target

      cargo build --release
    '';

    dontUseCargoInstallHook = true;
    installPhase = ''
      mkdir -p $out/bin
      cp target/release/gn-language-server $out/bin/
    '';

    meta = {
      description = "A language server for GN, and a tiny VSCode extension wrapping the server.";
      homepage = "https://github.com/google/gn-language-server";
      mainProgram = "gn-language-server";
      licenses = with lib.licenses; [asl20];
      maintainers = with lib.maintainers; [auguwu];
    };
  }
