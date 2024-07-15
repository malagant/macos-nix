{ config, pkgs, lib, ... }:
let
  user = import ./user.nix;
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
      atuin
      awscli2
      bat
      byobu
      # caffeine
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
      helix
      homesick
      jq
      k9s
      kind
      kubectl
      kubectx
      kubernetes-helm
      lazydocker
      lazygit
      neofetch
      neovim
      ollama
      podman
      python3
      ripgrep
      rustup
      solargraph
      starship
      tldr
      wezterm
      wget
      yazi
      zoxide
      (nerdfonts.override {
       fonts = [
         "Noto"
         "Iosevka"
         "JetBrainsMono"
       ];
      })
  ];

  # Misc configuration files --------------------------------------------------------------------{{{
  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.username = "${user.name}";

  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
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
  };
}
