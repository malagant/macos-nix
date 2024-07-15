{
  description = "Darwin configuration for Michael Johann";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, flake-utils, home-manager, darwin, ... }:
  let 
      utils = flake-utils;
      user = import ./user.nix;
  in
  {
    # My `nix-darwin` configs
    darwinConfigurations = {
      ${user.hostname} = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
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
        #
        # extraSpecialArgs = {
        #   inherit pkgs;
        # };
      };
    };
 };
}
