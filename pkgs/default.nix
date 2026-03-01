final: prev: {
  rustfs = prev.callPackage ./rustfs {};

  # fix for `picosvg` failing since I use JetBrains Mono as my main monospace font
  # related: https://github.com/NixOS/nixpkgs/issues/493679
  pythonPackagesExtensions =
    (prev.pythonPackagesExtensions or [])
    ++ [
      (py-final: py-prev: {
        picosvg = py-prev.picosvg.overridePythonAttrs (old: {
          doCheck = false;
        });
      })
    ];
}
