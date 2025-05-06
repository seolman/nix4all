{
	description = "nix for all";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nur = {
			url = "github:nix-community/NUR";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-wsl = {
			url = "github:nix-community/NixOS-WSL";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		darwin = {
			url = "github:nix-darwin/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, nur, nixos-wsl, darwin, stylix, ... }: let
		system = "x86_64-linux";
	in {
		nixosConfigurations = {
			nixoslaptop = nixpkgs.lib.nixosSystem {
				inherit system;
				modules = [
					home-manager.nixosModules.home-manager
					nur.modules.nixos.default
					stylix.nixosModules.stylix
					./configuration.nix
				];
			};	
			nixoswsl = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					nixos-wsl.nixosModules.default
					./configuration.nix
				];
			};	
		};
	};
}
