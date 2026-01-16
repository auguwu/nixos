{
  vscode-utils,
  gn-language-server,
  nix-vscode-extensions,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "gn";
    publisher = "Google";
    version = "1.11.6";
    hash = "sha256-PoSyzHhOz/fw9eIbmnjFIIxryVh/PdC1IKb36ykpn0E=";
  };

  postInstall = ''
    rm $out/$installPrefix/dist/gn-language-server
    ln -sf ${gn-language-server}/bin/gn-language-server \
      $out/$installPrefix/dist/gn-language-server
  '';

  meta = nix-vscode-extensions.vscode-marketplace.google.gn.meta or {};
}
