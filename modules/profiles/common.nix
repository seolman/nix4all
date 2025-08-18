{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # TODO: fix secret key
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.sshKeyPaths = [
      "/home/seolman/.ssh/secret"
    ];
    secrets."ssh/ed25519" = {
      owner = "root";
      mode = "0600";
    };
    secrets."tailscale/authKeyFile" = { };
    secrets."syncthing/nixosServer" = { };
    secrets."mongodb/password" = { };
    secrets."postgresql/password" = { };
    secrets."redis/password" = { };
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    nss.enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    qemu.swtpm.enable = true;
  };

  virtualisation.docker.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [];
    cups-pdf.enable = true;
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

  services.syncthing = {
    enable = true;
    extraFlags = [ "--no-default-folder" ];
    user = "seolman";
    group = "users";
    dataDir = "/home/seolman";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:8384";
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    hostKeys = [
      {
        type = "ed25519";
        path = config.sops.secrets."ssh/ed25519".path;
      }
    ];
  };

  services.postgresql = {
    enable = true;
    settings.port = 5432;
    initialScript = pkgs.writeText "init_db.sql" ''
      alter user postgres with password '${config.sops.secrets."postgresql/password".path}';
    '';
  };

  services.postgresqlBackup = {
    enable = true;
    databases = [];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    replication.masterPort = 3306;
    replication.masterPassword = config.sops.secrets."mysql/password".path;
  };

  services.mysqlBackup = {
    enable = true;
    databases = [];
  };

  # INFO 27017
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    bind_ip = "0.0.0.0";
    enableAuth = true;
    initialRootPasswordFile = config.sops.secrets."mongodb/password".path;
  };

  services.redis = {
    servers.dev = {
      enable = true;
      port = 6379;
      openFirewall = true;
      requirePassFile = config.sops.secrets."redis/password".path;
    };
  };

  # services.neo4j = {
  #   enable = true;
  # };

  environment.systemPackages = with pkgs; [
    base16-schemes

    zellij
    helix
  ];

  environment.variables = {
    EDITOR = "hx";
    GIT_EDITOR = "$EDITOR";
    _ZO_DOCTOR = "0";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nanum
  ];

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
