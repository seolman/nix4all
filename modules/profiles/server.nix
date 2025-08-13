{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.tailscale = {
    enable = true;
    # authKeyFile = config.sops.secrets.authKeyFile.path;
    extraSetFlags = ["--advertise-exit-node"];
  };
}
