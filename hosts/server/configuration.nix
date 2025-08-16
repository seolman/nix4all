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
    inputs.sops-nix.nixosModules.sops

    ./../../modules/profiles/common.nix
    ./../../modules/profiles/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixosserver";
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      8384
      3000
    ];
  };

  systemd.tmpfiles.rules = [
    "d /data 0775 root root -"
    "d /data/downloads 0770 qbittorrent media -"
    "d /data/media 0770 jellyfin media -"
    "d /data/media/movies 0770 jellyfin media -"
  ];

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
      "media"
    ];
    packages = with pkgs; [ ];
  };

  users.groups.media = { };

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
    presets = [ "plain-text-symbols" ];
  };

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  programs.zoxide = {
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
      "jellyfin.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };
        };
      };
      "radarr.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:7878";
            proxyWebsockets = true;
          };
        };
      };
      "prowlarr.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:9696";
            proxyWebsockets = true;
          };
        };
      };
      "gitea.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:3001";
            proxyWebsockets = true;
          };
        };
      };
      "grafana.minirack.home" = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:3000";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  services.mongodb = {
    package = pkgs.mongodb;
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
    lfs.enable = true;
    dump.enable = true;
    database = {
      type = "postgres";
      host = "192.168.8.132";
    };
    settings = {
      server.HTTP_PORT = 3001;
    };
  };

  # TODO
  services.prometheus = {
    enable = true;
  };

  # TODO
  services.grafana = {
    enable = true;
    settings = {
      server.http_port = 3000;
    };
  };

  # TODO
  services.n8n = {
    enable = true;
  };

  services.qbittorrent = {
    enable = true;
    group = "media";
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
    group = "media";
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    port = 8191;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
    settings.server.port = 9696;
  };

  services.radarr = {
    enable = true;
    user = "jellyfin";
    group = "media";
    openFirewall = true;
    settings.server.port = 7878;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    settings.server.port = 8989;
  };

  services.bazarr = {
    enable = true;
  };

  services.lidarr = {
    enable = true;
  };

  services.readarr = {
    enable = true;
  };

  services.jellyseerr = {
    enable = true;
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
        "android-phone" = {
          id = "LFGCTOR-LOFNQ4J-2IF7Z7X-BJTFAVX-6HXGWHA-VKCYNH3-IROPVDD-53QGQQ5";
        };
      };
      folders = { };
    };
  };

  # ERROR: 1.137
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

  # services.zigbee2mqtt = {};

  # TODO hostname
  # services.nextcloud = {
  #   enable = true;
  #   config.dbtype = "pgsql";
  # };

  # TODO docmost not in nixpkgs

  system.stateVersion = "25.05";
}
