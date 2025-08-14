{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.udisks2 = {
    enable = true;
  };

  services.gvfs = {
    enable = true;
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-routes" ];
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

    python313Full
    uv
    # python313Packages.python-lsp-server
    python313Packages.jedi-language-server
    ruff

    gcc
    gnumake
    # gdb
    # gtest
    clang
    # lldb
    cmake
    clang-tools

    rustc
    cargo
    # rust-analyzer

    lua
    luajit
    lua-language-server

    marksman
    markdown-oxide

    kitty
    ghostty
    wezterm
    alacritty
    rio
    foot
    contour

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

    adw-gtk3
    adwaita-icon-theme
    reversal-icon-theme
    whitesur-icon-theme
    apple-cursor
  ];
}
