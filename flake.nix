{
  description = "Linux configuration for Michael Johann";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      homeDir = builtins.getEnv "HOME";
      user = import "${homeDir}/.config/nix/user.nix";
    in
    {
      # My `home-manager` configurations for Linux
      homeConfigurations = {
        ${user.hostname} = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux"; # Change this to your system architecture, e.g., "aarch64-linux" if needed
          };
          
          # User-specific configuration module
          modules = [
            ./home.nix
            ./configuration.nix
          ];
        };
      };
    };
}
