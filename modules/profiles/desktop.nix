{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.gvfs = {
    enable = true;
  };
}
