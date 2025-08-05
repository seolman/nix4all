{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixosserver";
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 80 443 8384 ];
  };

  time.timeZone = "Asia/Seoul";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "tjfehdgns@gmail.com";
  };

  users.users.seolman = {
    isNormalUser = true;
    description = "seolman";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      # "media"
    ];
    packages = with pkgs; [];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "seolman" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    helix
    neovim
    zellij
    tmux
    lazygit
    yazi
    gemini-cli

    nixd
  ];

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

  services.openssh = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "syncthing.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:8384";
            proxyWebsockets = true;
          };
        };
      };
      "immich.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:2283";
            proxyWebsockets = true;
          };
        };
      };
      "qbittorrent.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:8080";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  # TODO initial user and password
  services.postgresql = {
    enable = true;
    settings.port = 5432;
  };

  # TODO
  services.mongodb = {
    enable = true;
  };

  # TODO
  services.neo4j = {
    enable = true;
  };

  # TODO
  services.elasticsearch = {
    enable = true;
  };

  # TODO
  services.rabbitmq = {
    enable = true;
  };

  # TODO
  services.minio = {
    enable = true;
  };

  # TODO
  services.gitea = {
    enable = true;
  };

  # TODO
  services.prometheus = {
    enable = true;
  };

  # TODO
  services.grafana = {
    enable = true;
  };

  # TODO
  services.n8n = {
    enable = true;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    openFirewall = true;
  };

  # services.sabnzbd = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # TODO
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };

  services.bazarr = {
    enable = true;
  };

  services.radarr = {
    enable = true;
  };

  services.lidarr = {
    enable = true;
  };

  services.readarr = {
    enable = true;
  };

  services.prowlarr = {
    enable = true;
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
        "android-phone" = { id = "LFGCTOR-LOFNQ4J-2IF7Z7X-BJTFAVX-6HXGWHA-VKCYNH3-IROPVDD-53QGQQ5"; };
      };
      folders = {};
    };
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;
    openFirewall = true;
  };

  # TODO
  # services.vaultwarden = {
  #   enable = true;
  #   dbBackend = "postgresql";
  # };

  # TODO
  # services.home-home-assistant = {};

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
