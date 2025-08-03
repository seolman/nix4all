{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixosserver";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ko_KR.UTF-8";
    LC_IDENTIFICATION = "ko_KR.UTF-8";
    LC_MEASUREMENT = "ko_KR.UTF-8";
    LC_MONETARY = "ko_KR.UTF-8";
    LC_NAME = "ko_KR.UTF-8";
    LC_NUMERIC = "ko_KR.UTF-8";
    LC_PAPER = "ko_KR.UTF-8";
    LC_TELEPHONE = "ko_KR.UTF-8";
    LC_TIME = "ko_KR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.seolman = {
    isNormalUser = true;
    description = "seolman";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    helix
    neovim
    zellij
    tmux
  ];

  programs.starship = {
    enable = true;
    presets = [ "plain-text-symbols" ];
  };

  services.openssh = {
    enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
