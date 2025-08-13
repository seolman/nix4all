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
}
