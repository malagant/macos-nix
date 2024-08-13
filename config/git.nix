{
  programs.git = {
    enable = true;
    userName = "Michael Johann";
    userEmail = "mjohann@rails-experts.com";
    difftastic.enable = true;
    aliases = {
      st = "status";
    };
    extraConfig = {
      credential = {
        helper = "store";
      };
    };
  };
}
