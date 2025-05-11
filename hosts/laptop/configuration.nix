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
	services.upower.enable = true;

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

	services.openssh = {
		enable = true;
		settings.PasswordAuthentication = false;
	};

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
					lctl)
				(defalias
					cap (tap-hold 100 100 esc lctl))
				(deflayer main
					lctl
					caps)'';
			devices = [
				"dev/input/by-path/platform-i8042-serio-0-event-kbd"
			];
		};
	};

	services.mpd = {
		enable = true;
		# musicDirectory = "~/Music";
	};

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

	xdg.terminal-exec.enable = true;

	xdg.mime.defaultApplications = {};

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

	boot.plymouth = {
		enable = true;
		theme = "nixos-bgrt";
		themePackages = with pkgs; [
			nixos-bgrt-plymouth
		];
	};

  services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.greetd}/bin/agreety --cmd niri-session";
			};
		};
	};

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

	programs.starship = {
		enable = true;
		presets = [ "plain-text-symbols" ];
	};

	programs.fzf = {
		fuzzyCompletion = true;
		keybindings = true;
	};

	qt = {
		enable = true;
		style = "adwaita-dark";
		platformTheme = "qt5ct";
	};

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
		clapboard
		gitoxide
		gitu
		gitui
		lazygit
		rsync
		fzf
		skim
		bat
		bottom
		translate-shell
		fastfetch

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
		# wezterm
		kitty
		# ghostty
		# alacritty
		# rio
		neovide
		# vscode
		# zed-editor
		# emacs
		# zathura
		# sioyek
		fuzzel
		# anyrun
		nemo-with-extensions
		# imv
		grimblast
		nwg-look
		obsidian
		obs-studio # screen capture not working
		vesktop
		brightnessctl
		libreoffice-qt6
		moonlight-qt
		gimp3
		blender
		# grimblast
		# hyprpicker
		cava
		trashy
		localsend
		udiskie
		mpv
		# pass
		gnupg
		swww
		# mako
		# swaynotificationcenter
		# swayosd
		networkmanagerapplet
		xwayland-satellite
		mangohud
		protonup-qt
		lutris
		ironbar
		sxhkd
		wev
		font-manager
		pwvucontrol
		wayland-utils
		inori
		tailscale-systray
		syncthingtray
		gtklock

		adw-gtk3
		adwaita-icon-theme
		whitesur-gtk-theme
		whitesur-icon-theme
		apple-cursor
	];

	environment.variables = {
		EDITOR = "hx";
		VISUAL = "neovide";
		NIXOS_OZONE_WL = "1";
		QT_QPA_PLATFORM = "wayland";
	};

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};
	
	system.stateVersion = "24.11";
}
