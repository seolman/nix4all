{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    # inputs.sops-nix.nixosModules.sops

    ../../modules/profiles/common.nix
    ../../modules/profiles/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixoslaptop";
  networking.networkmanager.enable = true;
  networking.firewall = {
    # allowedTCPPorts = [];
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

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

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
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.syncthing = {
    enable = true;
    extraFlags = [ "--no-default-folder" ];
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
      folders = { };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    nss.enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
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

  xdg.terminal-exec.enable = true;

  xdg.mime.defaultApplications = { };

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
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUrguVrbIcMvN1pSjvRQdQPIUSvYqrEij+bd7NrJZW3 tjfehdgns@gmail.com" # id_ed25519
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJgwMDEQXpvJN/FAFjeEmYcAxNVb5QEeznHXCHfAPCI tjfehdgns@gmail.com" # secret
    ];
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

  services.xserver.videoDrivers = [ "amdgpu" ];

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
    presets = [ "plain-text-symbols" ];
  };

  # programs.fzf = {
  #   fuzzyCompletion = true;
  #   keybindings = true;
  # };

  programs.skim = {
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
    deploy-rs
    cava

    # neovide
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
    batmon
    kubectl
    kubectx
    # minikube
    kubernetes-helm
    k9s
    pandoc
    # wgpu-native
    # sdl3
    peazip
    # figma-linux
    # notion-app-enhanced

    # mangohud
    # protonup-qt
    # lutris
  ];

  environment.variables = {
    # EDITOR = "hx";
    VISUAL = "zeditor";
    # GIT_EDITOR = "$EDITOR";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    _ZO_DOCTOR = "0";
    GOPATH = "/home/seolman/.go";
    KUBECONFIG = "/home/seolman/.kube/config";
  };

  system.stateVersion = "24.11";
}
