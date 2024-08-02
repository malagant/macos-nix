{ config, pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
  user = import "${homeDir}/.config/nix/user.nix";
in
{
  home.stateVersion = "24.05";

  imports = [
    ./config/alacritty.nix
    ./config/git.nix
    ./config/prompt.nix
    ./config/tmux.nix
    ./config/tools.nix
    ./config/wezterm.nix
    ./config/zsh.nix
  ];

  home.packages = with pkgs; [
    antidote
    atuin
    awscli2
    bat
    bruno
    byobu
    # caffeine
    cilium-cli
    clusterctl
    cmctl
    coreutils
    curl
    delta
    direnv
    docker
    docker-compose
    espanso
    fd
    fluxcd
    fzf
    fzf-git-sh
    git
    google-cloud-sdk
    hcloud
    helix
    homesick
    hubble
    jetbrains.webstorm
    jq
    k9s
    kind
    kluctl
    kubecolor
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    lazydocker
    lazygit
    mkcert
    neofetch
    neovim
    nodejs_20
    obsidian
    packer
    podman
    python3
    ripgrep
    rustup
    sketchybar-app-font
    solargraph
    starship
    talosctl
    terraform
    tldr
    tree
    wezterm
    wget
    yarn
    yazi
    yq
    zoxide
    (nerdfonts.override {
      fonts = [
        "Noto"
        "Iosevka"
        "JetBrainsMono"
      ];
    })
  ];

  home.shellAliases = {
    db = "nix run nix-darwin -- switch --impure --flake ~/.config/nix";
    zs = "source ~/.zshrc";
    ne = "nvim ~/.config/nix";
    k = "kubecolor";
    kgn = "k get nodes";
    kgns = "k get ns";
  };

  # Misc configuration files --------------------------------------------------------------------{{{
  # home.file.".zshrc".source = ./dotfiles/zshrc;
  home.username = "${user.name}";
  home.homeDirectory = "${user.homeDir}";

  xdg.configFile = {
    "sketchybar/sketchybarrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles/sketchybar/sketchybarrc";
      onChange = ''
        chmod +x ${config.xdg.configHome}/sketchybar/sketchybarrc
      '';
    };
  };

  home.file = {
    ".stack/config.yaml".text = lib.generators.toYAML { } {
      templates = {
        scm-init = "git";
        params = {
          author-name = "Michael Johann"; # config.programs.git.userName;
          author-email = "michael.johann@telekom.de"; # config.programs.git.userEmail;
          github-username = "malagant";
        };
      };
      nix.enable = true;
    };

    ".yabairc".text = ''
      #!/usr/bin/env sh
      # global settings
      yabai -m config mouse_follows_focus          off
      yabai -m config focus_follows_mouse          off
      yabai -m config window_placement             second_child
      yabai -m config window_topmost               off
      yabai -m config window_opacity               off
      yabai -m config window_opacity_duration      0.0
      yabai -m config window_shadow                on
      yabai -m config window_border                on
      yabai -m config window_border_width          4

      yabai -m config active_window_opacity        1.0
      yabai -m config normal_window_opacity        0.90
      yabai -m config split_ratio                  0.50
      yabai -m config auto_balance                 off
      yabai -m config mouse_modifier               fn
      yabai -m config mouse_action1                move
      yabai -m config mouse_action2                resize

      # general space settings
      yabai -m config layout                       bsp
      yabai -m config top_padding                  4
      yabai -m config bottom_padding               4
      yabai -m config left_padding                 4
      yabai -m config right_padding                4
      yabai -m config window_gap                   4

      yabai -m rule --add app="^CopyQ$" manage=off
      yabai -m rule --add app="^System Settings$" manage=off

      yabai -m space 1 --label one
      yabai -m space 2 --label two
      yabai -m space 3 --label three
      yabai -m space 4 --label four
      yabai -m space 5 --label five
      yabai -m space 6 --label six
      yabai -m space 7 --label seven
      yabai -m space 8 --label eight
      yabai -m space 9 --label nine
      yabai -m space 10 --label ten

      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m config external_bar all:$(sketchybar --query bar | jq .height):0

      echo "yabai configuration loaded.."
    '';

  };

  home.sessionVariables = {
    EDITOR = "nvim";
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    NIXPKGS_ALLOW_UNFREE = 1;
  };
}
