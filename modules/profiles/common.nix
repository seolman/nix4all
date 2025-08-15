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
    secrets."tailscale/authKeyFile" = { };
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

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.postgresql = {
    enable = true;
    settings.port = 5432;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  environment.systemPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nanum
    base16-schemes

    zellij
    helix
  ];

  environment.variables = {
    EDITOR = "hx";
    GIT_EDITOR = "$EDITOR";
    _ZO_DOCTOR = "0";
  };


  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
    image = config.lib.stylix.pixel "base00";
    fonts = {
      serif.name = "NanumSquareRound";
      sansSerif.name = "NanumSquareRound";
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
