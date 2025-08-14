{
  pkgs,
  machine,
  ...
}: {
  programs.ghostty = {
    # on macOS, ghostty is currently broken!
    enable = machine != "miki";
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrains Mono";
      theme = "rose-pine";
      font-size = 14;
    };
  };

  # view above; move to ghostty once it is not broken
  programs.alacritty = {
    enable = machine == "miki";
    settings = {
      terminal.shell = "${pkgs.zsh}/bin/zsh";

      # Rose Pine
      colors = {
        primary.background = "0x191724";
        primary.foreground = "0xe0def4";

        cursor.text = "0xe0def4";
        cursor.cursor = "0x524f67";

        selection.text = "0xe0def4";
        selection.background = "0x403d52";

        normal.black = "0x26233a";
        normal.red = "0xeb6f92";
        normal.green = "0x31748f";
        normal.yellow = "0xf6c177";
        normal.blue = "0x9ccfd8";
        normal.magenta = "0xc4a7e7";
        normal.cyan = "0xebbcba";
        normal.white = "0xe0def4";

        bright.black = "0x6e6a86";
        bright.red = "0xeb6f92";
        bright.green = "0x31748f";
        bright.yellow = "0xf6c177";
        bright.blue = "0x9ccfd8";
        bright.magenta = "0xc4a7e7";
        bright.cyan = "0xebbcba";
        bright.white = "0xe0def4";
        hints = {
          start.foreground = "#908caa";
          start.background = "#1f1d2e";

          end.foreground = "#6e6a86";
          end.background = "#1f1d2e";
        };
      };

      # font configuration
      font.size = 16;
      font.normal = {
        family = "JetBrains Mono";
        style = "Regular";
      };

      font.italic = {
        family = "JetBrains Mono";
        style = "Italic";
      };

      font.bold = {
        family = "JetBrains Mono";
        style = "Bold";
      };

      font.bold_italic = {
        family = "JetBrains Mono";
        style = "Bold Italic";
      };
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

  programs.zed-editor = {
    enable = true;
    extensions = [
      # languages
      "nix"
      "toml"
      "sql"
      "vue"
      "make"
      "html"
      "rust"
      "terraform"
      "dockerfile"
      "docker-compose"
      "emmet"

      # misc
      "git-firefly"
      "wakatime"
      "env"

      # themes
      "vitesse-theme-refined"
      "material-icon-theme"
    ];

    extraPackages = with pkgs; [
      clang-tools_18
      nil
    ];

    userSettings = {
      # Allows Zed to format all files
      format_on_save = "on";

      # Disables VIM mode. I hate VIM.
      vim_mode = false;

      # Sets tab size to 4 for all languages
      tab_size = 4;

      buffer_font_size = 17;
      buffer_font_family = "JetBrains Mono";

      current_line_highlight = "none";
      cursor_blink = true;

      ui_font_size = 16;
      ui_font_family = "Inter";

      theme = {
        mode = "system";
        light = "Vitesse Refined Light";
        dark = "Vitesse Refined Dark";
      };

      terminal = {
        font_family = "JetBrains Mono";
        font_size = 17;
      };

      features = {
        copilot = false;
      };

      telemetry = {
        diagnostics = true;
        metrics = false;
      };

      languages = {
        Nix = {
          language_servers = ["nil" "!nixd"];
          format_on_save = "on";
          tab_size = 2;
        };
      };

      lsp = {
        nil = {
          settings = {
            formatting = {
              command = ["nix" "fmt" "--" "--"];
            };

            nix = {
              binary = "${pkgs.nixVersions.stable}/bin/nix";
              maxMemoryMB = 4120; # ~4.1GiB is used for `nix flake show --legacy` for me.
              flake = {
                autoArchive = true;
                autoEvalInputs = true;
              };
            };
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    mesonlsp
  ];

  programs.vscode = {
    enable = machine != "miki";
    package = pkgs.vscode-insiders.overrideAttrs (old: {
      buildInputs = with pkgs; old.buildInputs ++ [krb5];
    });

    profiles.default = {
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        astro-build.astro-vscode
        llvm-vs-code-extensions.vscode-clangd
        ms-vscode-remote.remote-containers
        jnoortheen.nix-ide
        #rust-lang.rust-analyzer
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
        mesonbuild.mesonbuild
        ms-vscode.cmake-tools
        hashicorp.hcl
        github.vscode-github-actions
        yoavbls.pretty-ts-errors
        vue.volar
        opentofu.vscode-opentofu
        antfu.theme-vitesse
      ];

      userSettings = {
        ##                         LANGUAGE-SPECIFIC                       ##
        "[terraform-vars]"."editor.defaultFormatter" = "hashicorp.terraform";
        "[opentofu-vars]"."editor.defaultFormatter" = "OpenTofu.vscode-opentofu";
        "[terraform]"."editor.defaultFormatter" = "hashicorp.terraform";
        "[opentofu]"."editor.defaultFormatter" = "OpenTofu.vscode-opentofu";
        "[starlark]"."editor.defaultFormatter" = "BazelBuild.vscode-bazel";
        "[meson]"."editor.defaultFormatter" = "mesonbuild.mesonbuild";
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
      };
    };
  };
}
