{
  config,
  pkgs,
  inputs,
  ...
}:
{
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

  users.users.seolman = {
    isNormalUser = true;
    description = "seolman";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
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

  services.openssh = {
    enable = true;
  };

  services.traefik = {
    enable = true;
  };

  services.postgresql = {
    enable = true;
  };

  services.mongodb = {
    enable = true;
  };

  services.neo4j = {
    enable = true;
  };

  services.elasticsearch = {
    enable = true;
  };

  services.rabbitmq = {
    enable = true;
  };

  services.minio = {
    enable = true;
  };

  services.gitea = {
    enable = true;
  };

  services.prometheus = {
    enable = true;
  };

  services.grafana = {
    enable = true;
  };

  services.n8n = {
    enable = true;
  };

  services.jellyfin = {
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
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };

  services.vaultwarden = {
    enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
