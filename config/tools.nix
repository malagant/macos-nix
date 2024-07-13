{ unstable, ... }:
{
  programs = {
    bat = {
      enable = true;
    };
    eza = {
      enable = true;
    };
    fzf = {
      package = unstable.fzf;
      tmux = {
        enableShellIntegration = true;
      };
    };
  };
}
