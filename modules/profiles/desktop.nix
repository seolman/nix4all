{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.udisks2 = {
    enable = true;
  };

  services.gvfs = {
    enable = true;
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = ["--accept-routes"];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    wezterm
    kitty
    foot
    contour
    hyper
    tabby
  ];
}
