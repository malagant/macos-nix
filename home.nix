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
    ./config/zsh.nix
    ./config/prompt.nix
    ./config/tmux.nix
    ./config/wezterm.nix
    ./config/tools.nix
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
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    lazydocker
    lazygit
    mkcert
    neofetch
    neovim
    obsidian
    ollama
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
    wezterm
    wget
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
  };

  # Misc configuration files --------------------------------------------------------------------{{{
  # home.file.".zshrc".source = ./dotfiles/zshrc;
  home.username = "${user.name}";
  home.homeDirectory = "${user.homeDir}";

  home.file.".stack/config.yaml".text = lib.generators.toYAML { } {
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

  home.sessionVariables = {
    EDITOR = "nvim";
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    NIXPKGS_ALLOW_UNFREE = 1;
  };
}
