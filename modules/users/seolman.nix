{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.username = "seolman";
  home.homeDirectory = "/home/seolman";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [];

  home.file = {};

  home.sessionVariables = {};

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "tjfehdgns@gmail.com";
    userName = "seolman";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
