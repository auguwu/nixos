final: prev: {
  gn-language-server = prev.callPackage ./gn-language-server {};

  # this is for testing, we don't actually put `google-gn-vscode` in the extensions list
  google-gn-vscode-ext = prev.callPackage ./vscode/extensions/google.gn {};
}
