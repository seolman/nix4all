{ config, pkgs, inputs, ... }: {
	imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixoslaptop";
	networking.networkmanager.enable = true;

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
	i18n.inputMethod = {
		enable = true;
		type = "kime";
		kime = {
			iconColor = "White";
			daemonModules = [ "Xim" "Wayland" ];
			extraConfig = ''
engine:
  global_hotkeys:
    S-Space:
      behavior: !Toggle
      - Hangul
      - Latin
      result: Consume
    Esc:
      behavior: !Switch Latin
      result: Bypass'';
		};
		# type = "fcitx5";
		# fcitx5.addons = with pkgs; [
		# 	fcitx5-mozc
		# 	fcitx5-gtk
		# 	fcitx5-hangul
		# ];
	};

	# services.power-profiles-daemon.enable = false;
	services.auto-cpufreq.enable = true;
	services.auto-cpufreq.settings = {
	  battery = {
	     governor = "powersave";
	     turbo = "never";
	  };
	  charger = {
	     governor = "performance";
	     turbo = "auto";
	  };
	};

	services.printing = {
		enable = true;
		drivers = with pkgs; [ gutenprint hplip splix ];
		cups-pdf.enable = true;
	};

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = { General = { Experimental = true; }; };
	};
	services.blueman.enable = true;

	security.rtkit.enable = true;
	services.pipewire = {
	  enable = true;
		audio.enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;
	  pulse.enable = true;
		jack.enable = true;
		wireplumber.enable = true;
	};

	security.polkit.enable = true;
	security.soteria.enable = true;

	fonts = {
		enableDefaultPackages = false;
		packages = with pkgs; [
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			noto-fonts-emoji
			nerd-fonts.jetbrains-mono
			nanum
		];
		fontconfig = {
			enable = true;
			defaultFonts.serif = [ "NanumSquareRound Bold" ];
			defaultFonts.sansSerif = [ "NanumSquareRound Bold" ];
			defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
			defaultFonts.emoji = [ "Noto Color Emoji" ];
		};
	};

	services.openssh.enable = true;

	services.tailscale.enable = true;

	# programs.uwsm = {
	# 	enable = true;
	# 	waylandCompositors = {};
	# };

	# services.desktopManager.cosmic.enable = true;
	# services.displayManager.cosmic-greeter.enable = true;

  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

	# services.xserver.enable = true;
	# services.xserver.desktopManager.gnome.enable = true;

	services.kanata = {
		enable = true;
		keyboards."main" = {
			config = ''
				(defsrc
					caps
					lctl
				)

				(defalias
					cap (tap-hold 100 100 esc lctl)
				)

				(deflayer main
					lctl
					caps
				)
			'';
			devices = [
				"dev/input/by-path/platform-i8042-serio-0-event-kbd"
			];
		};
	};

	services.mpd.enable = true;

	services.flatpak.enable = true;
	systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

	services.syncthing = {
		enable = true;
		user = "seolman";
		group = "users";
		dataDir = "/home/seolman/Documents";
		configDir = "/home/seolman/.config/syncthing";
	};

	virtualisation.libvirtd = {
		enable = true;
		qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
	};
	programs.virt-manager.enable = true;

	virtualisation.docker.enable = true;

	# virtualisation.waydroid.enable = true;

	xdg.portal = {
		enable = true;
		config.common.default = "*";
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-gnome
			xdg-desktop-portal-wlr
		];
	};
	services.gnome.gnome-keyring.enable = true;

	users.users.seolman = {
		isNormalUser = true;
		description = "seolman";
		extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
		packages = with pkgs; [];
	};

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        "seolman" = import ./home.nix;
      };
    };

	nixpkgs.config.allowUnfree = true;

	programs.niri.enable = true;

	# programs.hyprland.enable = true;

	# programs.waybar.enable = true;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	services.xserver.videoDrivers = [ "amdgpu" ];

	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
	};

	programs.gamemode.enable = true;

	environment.systemPackages = with pkgs; [
		git
		tmux
		neovim
		zellij
		helix
		yazi
		ffmpeg
		p7zip
		jq
		poppler
		fd
		ripgrep
		zoxide
		resvg
		imagemagick
		ghostscript
		wl-clipboard
		gitu
		gitui
		lazygit
		rsync
		fzf
		skim
		bat
		bottom
		translate-shell

		gcc
		gnumake
		gdb
		gtest
		clang
		lldb
		cmake
		valgrind
		mono
		temurin-bin
		go
		rustc
		python3Minimal
		nodejs
		typescript
		lua
		luajit
		typst
		ansible
		sqlite

		nixd
		clang-tools
		python313Packages.python-lsp-server
		lua-language-server
		typescript-language-server
		gopls
		rust-analyzer
		jdt-language-server
		bash-language-server
		marksman
		tinymist
		sqls
		ansible-language-server
		vscode-langservers-extracted
		yaml-language-server
		taplo

		google-chrome
		firefox
		# nur.repos.natsukium.zen-browser
		# wezterm
		kitty
		# ghostty
		# alacritty
		# rio
		neovide
		# zed-editor
		# emacs
		# zathura
		# sioyek
		fuzzel
		# anyrun
		nemo-with-extensions
		grimblast
		nwg-look
		obsidian
		obs-studio
		vesktop
		# vscode
		brightnessctl
		libreoffice-unwrapped
		moonlight-qt
		gimp3
		# aseprite-unfree # not working
		blender
		grimblast
		hyprpicker
		cava
		trashy
		localsend
		udiskie
		mpv-unwrapped
		pass
		gnupg
		swww
		adw-gtk3
		adwaita-icon-theme
		# mako
		swaynotificationcenter
		swayosd
		networkmanagerapplet
		xwayland-satellite
		mangohud
		protonup-qt
		lutris
		ironbar
		sxhkd
		wev
		font-manager
	];

	environment.variables = {
		EDITOR = "hx";
		VISUAL = "neovide";
		NIXOS_OZONE_WL = "1";
	};

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	system.stateVersion = "24.11";
}
