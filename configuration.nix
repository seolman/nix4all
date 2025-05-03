{ config, pkgs, ... }: {
	imports = [
		./hardware-configuration.nix
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
		type = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-mozc
			fcitx5-gtk
			fcitx5-hangul
		];
	};

	security.rtkit.enable = true;
	services.pipewire = {
	  enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;
	  pulse.enable = true;
	};

	fonts = {
		enableDefaultPackages = true;
		packages = with pkgs; [
			noto-fonts-cjk-sans
			nerd-fonts.jetbrains-mono
		];
	};

	services.openssh.enable = true;

	services.tailscale.enable = true;

	services.desktopManager.cosmic.enable = true;
	services.displayManager.cosmic-greeter.enable = true;

  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

	virtualisation.docker.enable = true;

	users.users.seolman = {
		isNormalUser = true;
		description = "seolman";
		extraGroups = [ "networkmanager" "wheel" "docker" ];
		packages = with pkgs; [];
	};

	nixpkgs.config.allowUnfree = true;

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
		wl-clipboard

		gitu
		gitui
		lazygit

		rsync

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
		wezterm
		ghostty
		neovide
		wluma # brightness
	];

	environment.variables = {
		EDITOR = "hx";
	};

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	
	system.stateVersion = "24.11";
}
