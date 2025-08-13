{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  sops.secrets.tailscale.authKeyFile = {};
  services.tailscale = {
    authKeyFile = config.sops.secrets.authKeyFile.path;
    extraSetFlags = ["--advertise-exit-node"];
  };
}
