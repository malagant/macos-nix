{ unstable, ... }:
{
  programs = {
    fzf = {
      enable = true;
    };
    htop = {
      enable = true;
      settings = {
        show_program_path = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    bat = {
      enable = true;
    };
    eza = {
      enable = true;
    };
  };
}
