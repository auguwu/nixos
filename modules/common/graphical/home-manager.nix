{
  pkgs,
  machine,
  ...
}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrains Mono";
      theme = "Material Darker";
      font-size = 14;
    };
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      color_align = {
        mode = "horizontal";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-insiders.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [pkgs.krb5];
    });

    profiles.default = {
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        astro-build.astro-vscode
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode-remote.remote-containers
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        mkhl.direnv
        ms-azuretools.vscode-docker
        github.vscode-github-actions
        tamasfe.even-better-toml
        golang.go
        hashicorp.terraform
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        xaver.clang-format
        skellock.just
        unifiedjs.vscode-mdx
        wakatime.vscode-wakatime
        ms-vscode.powershell
        catppuccin.catppuccin-vsc-icons
        bazelbuild.vscode-bazel
        ms-vscode.cmake-tools
        hashicorp.hcl
        github.vscode-github-actions
        yoavbls.pretty-ts-errors
        vue.volar
        opentofu.vscode-opentofu
        antfu.theme-vitesse
        ms-python.python
        ms-azuretools.vscode-docker
        ms-azuretools.vscode-containers
      ];

      userSettings = {
        ##                         LANGUAGE-SPECIFIC                       ##
        "[terraform-vars]"."editor.defaultFormatter" = "hashicorp.terraform";
        "[opentofu-vars]"."editor.defaultFormatter" = "opentofu.vscode-opentofu";
        "[terraform]"."editor.defaultFormatter" = "hashicorp.terraform";
        "[opentofu]"."editor.defaultFormatter" = "opentofu.vscode-opentofu";
        "[starlark]"."editor.defaultFormatter" = "BazelBuild.vscode-bazel";
        "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
        "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "[cpp]"."editor.defaultFormatter" = "xaver.clang-format";
        "[c]"."editor.defaultFormatter" = "xaver.clang-format";
        "[h]"."editor.defaultFormatter" = "xaver.clang-format";

        "[yaml]"."editor.quickSuggestions" = {
          other = true;
          comments = true;
          strings = true;
        };

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.tabSize" = 2;
        };

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings".nil = {
          formatting.command = ["nix" "fmt" "--" "--"];
          nix = {
            binary = "${pkgs.nixVersions.stable}/bin/nix";
            maxMemoryMB = 8192;
            flake.autoArchive = true;
            flake.autoEvalInputs = true;
          };
        };

        "clang-format.executable" = "${pkgs.clang-tools}/bin/clang-format";

        "opentofu.languageServer.enable" = true;
        "opentofu.languageServer.path" = "${pkgs.tofu-ls}/bin/tofu-ls";
        "opentofu.languageServer.tofu.path" = "${pkgs.opentofu}/bin/tofu";
        "opentofu.experimentalFeatures.validateOnSave" = true;

        # unfortunately i need powershell to exist
        # i wish it didn't tho but life is life
        "powershell.powerShellDefaultVersion" = "nixpkgs";
        "powershell.powerShellAdditionalExePaths" = {
          "nixpkgs" = "${pkgs.powershell}/bin/pwsh";
        };

        ##                            WORKBENCH                             ##
        "workbench.colorTheme" = "Vitesse Dark";
        "workbench.iconTheme" = "catppuccin-latte";
        "workbench.startupEditor" = "none";

        ##                            EDITOR                                ##
        "editor.tabSize" = 4;
        "editor.insertSpaces" = true;
        "editor.parameterHints.enabled" = false;
        "editor.inlineSuggest.enabled" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "editor.bracketPairColorization.enabled" = false;
        "editor.fontFamily" = "'JetBrains Mono', Consolas, 'Courier New', monospace";
        "editor.fontSize" = 17;
        "editor.minimap.enabled" = false;
        "editor.detectIndentation" = false;
        "editor.largeFileOptimizations" = false;
        "editor.semanticHighlighting.enabled" = false;
        "editor.stickyScroll.enabled" = false;
        "editor.quickSuggestions" = {
          "other" = true;
          "comments" = false;
          "strings" = false;
        };

        ## MISC ##
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        "debug.javascript.codelens.npmScripts" = "never";

        "git.timeline.showAuthor" = false;

        "diffEditor.ignoreTrimWhitespace" = false;

        "typescript.updateImportsOnFileMove.enabled" = "never";

        "terminal.integrated.defaultProfile.windows" = "PowerShell";
        "terminal.integrated.tabs.enabled" = true;

        "eslint.validate" = [
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
          "html"
          "vue"
          "astro"
        ];

        "eslint.probe" = [
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
          "html"
          "vue"
          "astro"
        ];

        "security.workspace.trust.untrustedFiles" = "open";
        "notebook.cellToolbarLocation" = {
          "juypter-notebook" = "left";
          "default" = "right";
        };

        "prettier.vueIndentScriptAndStyle" = true;
        "prettier.requireConfig" = true;

        "redhat.telemetry.enabled" = false;

        "go.toolsManagement.autoUpdate" = true;

        "javascript.updateImportsOnFileMove.enabled" = "never";

        "vs-kubernetes"."vs-kubernetes.crd-code-completion" = "enabled";

        ## FILES ##
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "files.associations" = {
          ".*-version" = "plaintext";
        };

        ## WINDOW ##
        "window.zoomLevel" =
          if machine == "kotoha"
          then 0.6
          else 0.7;

        "window.titleBarStyle" = "custom";

        ## TERMINAL ##
        "terminal.integrated.fontSize" = 16;

        ## DOCKER COMPOSE ##
        "[dockercompose]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
          "editor.defaultFormatter" = "redhat.vscode-yaml";
          "editor.quickSuggestions" = {
            "other" = true;
            "comments" = false;
            "strings" = true;
          };
        };
      };
    };
  };
}
