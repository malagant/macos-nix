{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
  user = import "${homeDir}/.config/nix/user.nix";
in
{
  # Nix configuration ------------------------------------------------------------------------------
  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "${user.name}"
  ];

  nix.configureBuildUsers = true;

  nix.gc.automatic = true;
  nix.gc.options = "--max-freed $((25 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    build-users-group = nixbld
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableFzf = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.yabai = {
    enable = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      top_padding = 36;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };
    extraConfig = ''
      		yabai -m rule --add app='System Preferences' manage=off
    '';
  };

  services.sketchybar = {
    enable = true;
    config = ''
      sketchybar --bar height=24
      sketchybar --update
      echo "sketchybar configuration loaded.."
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
    '';
  };

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    alacritty
    docker
    docker-compose
    git
    grafana
    iterm2
    kitty
    neovim
    podman
    podman-tui
    podman-compose
    raycast
    vim
    wezterm
    wget
  ];

  # https://github.com/nix-community/home-manager/issues/423
  programs.nix-index.enable = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  users.users.${user.name}.home = "${user.homeDir}";
}
