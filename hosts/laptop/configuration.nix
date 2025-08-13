{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ../../modules/profiles/common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixoslaptop";
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
  '';

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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  # hardware.fancontrol = {
  #   enable = true;
  #   config = '''';
  # };
  # programs.coolercontrol.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      energy_performance_preference = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "powersave";
      energy_performance_preference = "powersave";
      turbo = "never";
    };
  };
  # services.thermald = {
  #   enable = true;
  #   ignoreCpuidCheck = true;
  # };
  services.upower.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      splix
    ];
    cups-pdf.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  security.polkit.enable = true;
  security.soteria.enable = true;

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
      nanum
    ];
    fontconfig = {
      enable = true;
      defaultFonts.serif = ["NanumSquareRound Bold"];
      defaultFonts.sansSerif = ["NanumSquareRound Bold"];
      defaultFonts.monospace = ["JetBrainsMono Nerd Font"];
      defaultFonts.emoji = ["Noto Color Emoji"];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # programs.ssh = {
  #   startAgent = true;
  # };

  services.tailscale = {
    enable = true;
    extraUpFlags = ["--accept-routes"];
  };

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.udisks2 = {
    enable = true;
  };

  services.gvfs = {
    enable = true;
  };

  services.kanata = {
    enable = true;
    keyboards."main" = {
      config = ''
        (defsrc
        	caps
        	lctl lmet lalt)
        (defalias
        	cap (tap-hold 100 100 esc lctl))
        (deflayer main
        	lctl
        	caps lalt lmet)'';
      devices = [
        "dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
    };
  };

  services.mpd = {
    enable = true;
    # musicDirectory = "~/Music";
  };

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.syncthing = {
    enable = true;
    extraFlags = ["--no-default-folder"];
    user = "seolman";
    group = "users";
    dataDir = "/home/seolman";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:8384";
    settings = {
      devices = {
        "nixosserver" = {
          id = "7R3GJ6N-NT77P74-BV7NVUU-2XHQF5Y-QBK227A-X3SEXQE-PO7WH7C-HAAGKQJ";
          name = "nixos-server";
        };
      };
      folders = {};
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    nss.enable = true;
    qemu.vhostUserPackages = with pkgs; [virtiofsd];
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;

  # virtualisation.waydroid.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
  services.gnome.gnome-keyring.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "deepseek-coder-v2:16b"
    ];
  };

  services.postgresql = {
    enable = true;
  };

  xdg.terminal-exec.enable = true;

  xdg.mime.defaultApplications = {};

  users.users.seolman = {
    isNormalUser = true;
    description = "seolman";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
    ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  programs.niri.enable = true;

  # boot.plymouth = {
  # 	enable = true;
  # 	theme = "nixos-bgrt";
  # 	themePackages = with pkgs; [
  # 		nixos-bgrt-plymouth
  # 	];
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
        user = "seolman";
      };
    };
    greeterManagesPlymouth = true;
  };

  # programs.hyprland.enable = true;

  # programs.waybar.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # wlrobs
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];

  programs.xwayland.enable = true;

  # programs.gamescope = {
  #   enable = true;
  #   capSysNice = true;
  # };

  # programs.steam = {
  #   enable = true;
  #   gamescopeSession.enable = true;
  # };

  # programs.gamemode.enable = true;

  # qt = {
  #   enable = true;
  #   style = "adwaita-dark";
  #   platformTheme = "qt5ct";
  # };

  programs.starship = {
    enable = true;
    presets = ["plain-text-symbols"];
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.zoxide = {
    enable = true;
  };

  # programs.zsh = {
  #   enable = true;
  #   histSize = 10000;
  #   enableBashCompletion = true;
  #   syntaxHighlighting.enable = true;
  #   autosuggestions.enable = true;
  # };

  programs.fish = {
    enable = true;
  };

  # programs.tmux = {
  #   enable = true;
  #   plugins = with pkgs; [ ];
  #   terminal = "screen-256color";
  #   shortcut = "g";
  #   historyLimit = 10000;
  #   escapeTime = 0;
  #   baseIndex = 1;
  #   keyMode = "vi";
  #   customPaneNavigationAndResize = true;
  #   extraConfig = '''';
  # };

  # programs.direnv = {
  #   enable = true;
  #   silent = true;
  # };

  environment.systemPackages = with pkgs; [
    inputs.neovim-overlay.packages.${pkgs.system}.default
    git
    zellij
    helix
    yazi
    ffmpeg
    p7zip
    jq
    poppler
    poppler-utils
    fd
    ripgrep
    zoxide
    resvg
    imagemagick
    ghostscript
    wl-clipboard
    clapboard
    gitoxide
    gitu
    lazygit
    github-cli
    delta
    rsync
    fzf
    skim
    bat
    bottom
    translate-shell
    fastfetch
    xh
    macchina
    nushell
    tokei
    clock-rs
    eza
    dust
    hyperfine
    fselect
    ripgrep-all
    just
    mask
    presenterm
    termusic
    yt-dlp
    procs
    pipes-rs
    tinyxxd
    hextazy
    unzip
    codesnap
    gemini-cli
    awscli2
    google-cloud-sdk
    github-mcp-server
    turso-cli
    argocd
    piano-rs
    ssh-to-age
    sops
    age
    agenix-cli
    grex
    immich-cli
    opencode

    gcc
    gnumake
    # gdb
    # gtest
    clang
    # lldb
    cmake
    # valgrind
    # mono
    # temurin-bin
    # spring-boot-cli
    # gradle
    # kotlin
    go
    rustc
    cargo
    python313Full
    uv
    nodejs_latest
    typescript
    deno
    bun
    lua
    luajit
    typst
    ansible
    sqlite
    postgresql
    pgcli
    mariadb
    usql
    nixd
    # nil
    alejandra
    clang-tools
    # python313Packages.python-lsp-server
    python313Packages.jedi-language-server
    ruff
    lua-language-server
    typescript-language-server
    # nodePackages_latest.mocha
    webpack-cli
    gopls
    rust-analyzer
    jdt-language-server
    bash-language-server
    marksman
    markdown-oxide
    tinymist
    sqls
    ansible-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    superhtml
    yaml-language-server
    taplo
    eslint
    prettier
    # docker-language-server
    dockerfile-language-server-nodejs
    docker-compose-language-service
    lsp-ai

    google-chrome
    firefox
    wezterm
    kitty
    ghostty
    # neovide
    vscode
    zed-editor
    # zathura
    sioyek
    fuzzel
    # rofi-wayland
    nemo-with-extensions
    nwg-look
    obsidian
    # vesktop
    brightnessctl
    libreoffice-qt6
    # moonlight-qt
    # gimp3
    # blender
    # grimblast
    # hyprpicker
    cava
    trashy
    localsend
    udiskie
    mpv
    # pass
    # gnupg
    swww
    # mako
    # swaynotificationcenter
    # swayosd
    networkmanagerapplet
    xwayland-satellite
    ironbar
    sxhkd
    # wev
    font-manager
    pwvucontrol
    wayland-utils
    # inori
    # tailscale-systray
    tail-tray
    # syncthingtray
    gtklock
    # wf-recorder
    kalker
    # libqalculate
    # qalculate-gtk
    # shotcut
    # kmod
    # fanctl
    # fan2go
    batmon
    # eclipses.eclipse-java
    # android-studio
    # cacert
    # gnome-shell
    kubectl
    kubectx
    # minikube
    kubernetes-helm
    k9s
    pandoc
    # audacity
    # aseprite
    # blender
    # lmms
    # famistudio
    # klystrack # WARN sdl compile error
    # furnace
    # ldtk
    # pixelorama
    # godot
    # wgpu-native
    # sdl3
    peazip
    # tic-80
    # waveterm
    # figma-linux
    # notion-app-enhanced

    # mangohud
    # protonup-qt
    # lutris

    base16-schemes
    adw-gtk3
    adwaita-icon-theme
    reversal-icon-theme
    whitesur-icon-theme
    apple-cursor
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
    image = config.lib.stylix.pixel "base01";
    polarity = "dark";
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "neovide";
    GIT_EDITOR = "$EDITOR";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    _ZO_DOCTOR = "0";
    GOPATH = "/home/seolman/.go";
    KUBECONFIG = "/home/seolman/.kube/config";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.11";
}
