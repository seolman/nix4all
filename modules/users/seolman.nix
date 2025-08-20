{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.username = "seolman";
  home.homeDirectory = "/home/seolman";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [ ];

  home.file = { };

  home.sessionVariables = { };

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

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = lib.mkForce "vesper";
      editor = {
        line-number = "relative";
        continue-comments = false;
        completion-timeout = 5;
        preview-completion-insert = false;
        completion-trigger-len = 1;
        # completion-replace = true;
        true-color = true;
        undercurl = true;
        color-modes = true;
        trim-trailing-whitespace = true;
        popup-border = "popup";
        auto-pairs = false;
        statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
            "workspace-diagnostics"
          ];
          center = [
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "primary-selection-length"
            "position"
            "position-percentage"
            "spacer"
          ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        lsp = {
          display-progress-messages = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        auto-save = {
          after-delay.enable = true;
          after-delay.timeout = 1000;
        };
        gutters.line-numbers.min-width = 4;
        smart-tab = {
          enable = true;
          supersede-menu = true;
        };
        inline-diagnostics.cursor-line = "hint";
      };
      keys.insert = {
        "C-[" = "normal_mode";
      };
      keys.normal = {
        "C-u" = ["page_cursor_half_up" "align_view_center"];
        "C-p" = ["page_cursor_half_down" "align_view_center"];
        tab = "expand_selection";
        S-tab = "shrink_selection";
        " " = {
          i = ":toggle-option lsp.display-inlay-hints";
        };
      };
    };
  };
}
