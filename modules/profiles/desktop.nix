{
  config,
  pkgs,
  inputs,
  ...
}:
{
    stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
    image = config.lib.stylix.pixel "base00";
    fonts = {
      serif.name = "NanumSquareRound Bold";
      sansSerif.name = "NanumSquareRound Bold";
      monospace.name = "JetBrainsMono Nerd Font";
      emoji.name = "Noto Color Emoji";
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 14;
      };
    };
    polarity = "dark";
  };

  i18n.inputMethod = {
    enable = true;
    type = "kime";
    kime = {
      iconColor = "White";
      daemonModules = [
        "Xim"
        "Wayland"
      ];
      extraConfig = ''
        engine:
          global_hotkeys:
            S-Space:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            Esc:
              behavior: !Switch Latin
              result: Bypass'';
    };
    # type = "fcitx5";
    # fcitx5.addons = with pkgs; [
    # 	fcitx5-mozc
    # 	fcitx5-gtk
    # 	fcitx5-hangul
    # ];
  };

  services.udisks2 = {
    enable = true;
  };

  services.gvfs = {
    enable = true;
  };

  services.blueman.enable = true;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  security.polkit.enable = true;

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-routes" ];
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "deepseek-coder-v2:16b"
    ];
  };

  environment.systemPackages = with pkgs; [
    nixd
    nil
    nixfmt-tree

    nodejs_latest
    typescript
    deno
    bun
    typescript-language-server
    typescript-go
    vscode-langservers-extracted
    emmet-language-server
    tailwindcss-language-server
    superhtml
    eslint
    prettier

    go
    gopls

    python3Full
    uv
    # python313Packages.python-lsp-server
    # python313Packages.jedi-language-server
    ruff

    gcc
    gnumake
    gdb
    # gtest
    clang
    lldb
    cmake
    clang-tools

    temurin-bin
    spring-boot-cli
    jdt-language-server

    lua
    luajit
    lua-language-server

    rustc
    cargo
    rust-analyzer

    marksman
    markdown-oxide

    typst
    tinymist

    ansible
    ansible-language-server

    yaml-language-server
    bash-language-server
    taplo

    sqlite
    usql
    sqls

    # valgrind
    # mono
    # gradle
    # kotlin
    # docker-language-server
    dockerfile-language-server-nodejs
    docker-compose-language-service
    lsp-ai

    kitty
    ghostty
    wezterm
    alacritty

    google-chrome
    firefox

    vscode
    zed-editor
    # eclipses.eclipse-java
    # android-studio

    tic-80
    aseprite
    blender
    godot
    audacity
    # lmms
    # famistudio
    # klystrack # WARN sdl compile error
    # furnace
    # ldtk
    # pixelorama

    adw-gtk3
    adwaita-icon-theme
    reversal-icon-theme
    whitesur-icon-theme
    apple-cursor
  ];

  programs.virt-manager.enable = true;
}
