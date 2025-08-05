{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
  ];

  networking.hostName = "nixoswsl";

  time.timeZone = "Asia/Seoul";

  services.openssh = {
    enable = true;
    ports = [22];
  };

  programs.ssh.startAgent = true;

  services.syncthing = {
    enable = true;
    user = "seolman";
    group = "users";
    dataDir = "/home/seolman/Documents";
    configDir = "/home/seolman/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      devices = {
        "oracle-instance" = {id = "G4WTCTC-UVQ3R57-KO2HA4K-T5Q6C3N-DELVUP7-LITVG4M-CAQUMBO-QIP4PAI";};
      };
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.postgresql = {
    enable = true;
  };

  # programs.tmux = {
  # 	enable = true;
  # 	plugins = with pkgs.tmuxPlugins; [
  # 		resurrect
  # 		continuum
  # 	];
  # 	extraConfig = ''
  # 		run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
  # 		run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
  # 	'';
  # };

  programs.starship = {
    enable = true;
    presets = ["plain-text-symbols"];
  };

  programs.fish = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    gdb
    gtest
    clang
    clang-tools
    lldb
    cmake
    valgrind
    mono
    temurin-bin
    jdt-language-server
    go
    gopls
    rustc
    rust-analyzer
    python3Minimal
    python313Packages.python-lsp-server
    nodejs_latest
    typescript
    typescript-language-server
    vscode-langservers-extracted
    lua
    luajit
    lua-language-server
    typst
    tinymist
    nixd
    bash-language-server
    marksman
    markdown-oxide
    sqls
    ansible
    ansible-language-server
    templ
    yaml-language-server

    sqlite

    git
    git-lfs
    gitoxide
    lazygit
    gitui
    gh
    neovim
    tmux
    nnn
    fzf
    uutils-coreutils
    uutils-findutils
    uutils-diffutils
    helix
    zellij
    yazi
    skim
    bat
    ffmpeg
    p7zip
    jq
    poppler
    fd
    ripgrep
    zoxide
    imagemagick
    rsync
    atac
    starship
    fastfetch
    macchina

    kubectl
  ];

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nanum
      nerd-fonts.jetbrains-mono
      nerd-fonts.d2coding
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  wsl = {
    enable = true;
    defaultUser = "seolman";
    interop.includePath = false;
  };

  system.stateVersion = "24.11";
}
