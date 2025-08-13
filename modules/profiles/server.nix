{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.tailscale = {
    # authKeyFile = config.sops.secrets.authKeyFile.path;
    extraSetFlags = ["--advertise-exit-node"];
  };
}
