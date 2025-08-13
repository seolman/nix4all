{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale/authKeyFile".path;
    extraSetFlags = ["--advertise-exit-node"];
  };
}
