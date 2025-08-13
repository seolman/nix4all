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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    nixos-wsl,
    darwin,
    stylix,
    sops-nix,
    neovim-overlay,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      nixoslaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.seolman = import ./hosts/laptop/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
          nur.modules.nixos.default
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
          ./hosts/laptop/configuration.nix
        ];
      };
      nixoswsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          nur.modules.nixos.default
          stylix.nixosModules.stylix
          nixos-wsl.nixosModules.default
          ./hosts/wsl/configuration.nix
        ];
      };
      nixosserver = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          nur.modules.nixos.default
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
          ./hosts/server/configuration.nix
        ];
      };
    };
  };
}
