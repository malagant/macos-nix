{
  programs.zsh = {
    enable = true;
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    antidote = {
      enable = true;
      plugins = [
        "djui/alias-tips"
        "rupa/z"
        "caarlos0/zsh-mkc"
        "zsh-users/zsh-completions"
        "caarlos0/zsh-open-github-pr"
        "ohmyzsh/ohmyzsh path:plugins/aws"
        "romkatv/zsh-bench kind:path"
        "olets/zsh-abbr    kind:defer"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
        "g-plane/zsh-yarn-autocompletions"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "belak/zsh-utils path:editor"
        "belak/zsh-utils path:history"
        "belak/zsh-utils path:prompt"
        "belak/zsh-utils path:utility"
        "belak/zsh-utils path:completion"
        "mattmc3/zfunctions"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-history-substring-search"
      ];
    };
  };
}
