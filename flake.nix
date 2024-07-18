{
  description = "Darwin configuration for Michael Johann";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/aarch64-darwin";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # flake-utils.url = "github:numtide/flake-utils";
    # flake-utils.inputs.systems.follows = "systems";
  };

  outputs = inputs@{ nixpkgs, flake-utils, home-manager, darwin, ... }:
    let
      # utils = flake-utils;
      homeDir = builtins.getEnv "HOME";
      user = import "${homeDir}/.config/nix/user.nix";
      # user = import ./user.nix;
    in
    {
      # My `nix-darwin` configs
      darwinConfigurations = {
        ${user.hostname} = darwin.lib.darwinSystem {
          system = builtins.currentSystem;
          modules = [
            # Main `nix-darwin` config
            ./configuration.nix
            # `home-manager` module
            home-manager.darwinModules.home-manager
            {
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user.name} = import ./home.nix;
            }
          ];
        };
      };
    };
}
