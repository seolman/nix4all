{
  config,
  pkgs,
  inputs,
  ...
}: {
  # sops = {
  #   defaultSopsFile = ../../secrets.yaml;
  #   secrets.tailscale = {
  #     sopsFile = ../../secrets.yaml;
  #   };
  # };

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

  services.tailscale = {
    enable = true;
    extraUpFlags = ["--accept-routes"];
  };

  environment.systemPackages = with pkgs; [
    base16-schemes
    tailscale
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
    image = config.lib.stylix.pixel "base00";
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
