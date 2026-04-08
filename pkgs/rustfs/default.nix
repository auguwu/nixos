{
  fetchFromGitHub,
  lib,
  protobuf,
  pkg-config,
  openssl,
  rustPlatform,
  stdenv,
  apple-sdk_15,
}:
rustPlatform.buildRustPackage rec {
  pname = "rustfs";
  version = "1.0.0-alpha.91";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = version;
    hash = "sha256-mglrxo81ptB37DIf5uNOLqri2AvVx+IXD8/IpLcQJWM=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      apple-sdk_15
    ];

  cargoBuildFlags = [
    "--package"
    "rustfs"

    # when i add this to nixpkgs, i KNOW they wont accept this
    "--ignore-rust-version"
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  cargoTestFlags = ["--ignore-rust-version"];

  RUSTFLAGS = "--cfg tokio_unstable";
  PROTOC = "${protobuf}/bin/protoc";

  doCheck = false;

  meta = {
    description = "High-performance S3-compatible object storage";
    homepage = "https://rustfs.com";
    licenses = [lib.licenses.asl20];
    maintainers = [lib.maintainers.auguwu];
    mainProgram = "rustfs";
  };
}
