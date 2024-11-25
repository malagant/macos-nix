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
    aerospace
    antidote
    atuin
    awscli2
    bat
    bruno
    byobu
    cargo-audit
    cargo-binutils
    cargo-watch
    clusterctl
    direnv
    discord
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
    kubeseal
    kustomize
    lazydocker
    lazygit
    llvm_18
    mkcert
    neofetch
    neovim
    nodejs_20
    nushell
    obsidian
    packer
    podman
    python3
    ripgrep
    rustup
    solargraph
    starship
    talosctl
    terraform
    tldr
    tree
    vscode
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
        "D2Coding"
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
    kgp = "k get pods";
    kl = "k logs";
    clc = "/usr/local/bin/clusterctl";
    ve = "nvim ~/.config/nvim";
    k8s-show-ns = " kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found  -n";
  };

  # Misc configuration files --------------------------------------------------------------------{{{
  # home.file.".zshrc".source = ./dotfiles/zshrc;
  home.username = "${user.name}";
  home.homeDirectory = "${user.homeDir}";

  xdg.configFile = {
    "aerospace/aerospace.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles/aerospace/aerospace.toml";
    };
    "starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles/starship/starship.toml";
    };
    "config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles/atuin/config.toml";
    };
    "karabiner/karabiner.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles/karabiner/karabiner.json";
    };
  };

  home.file = {
    ".stack/config.yaml".text = lib.generators.toYAML { } {
      templates = {
        scm-init = "git";
        params = {
          author-name = "Michael Johann"; # config.programs.git.userName;
          author-email = "mjohann@rails-experts.com"; # config.programs.git.userEmail;
          github-username = "malagant";
        };
      };
      nix.enable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    NIXPKGS_ALLOW_UNFREE = 1;
  };
}
