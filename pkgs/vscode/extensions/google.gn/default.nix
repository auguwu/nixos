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
    hash = "";
  };

  postInstall = ''
    ln -sf ${gn-language-server}/bin/gn-language-server \
      $out/$installPrefix/bin/gn-language-server
  '';

  meta = nix-vscode-extensions.vscode-marketplace.google.gn.meta or {};
}
