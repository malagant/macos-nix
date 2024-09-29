{
  programs.alacritty.enable = true;
  home.file.".config/alacritty/alacritty.toml".text = ''
    import = [
      "~/.config/alacritty/themes/themes/tokyo-night.toml"
    ]

    [font]
    size = 18.0

    [font.bold]
    family = "Iosevka Nerd Font"
    style = "Bold"

    [font.bold_italic]
    family = "Iosevka Nerd Font"
    style = "Bold Italic"

    [font.italic]
    family = "Iosevka Nerd Font"
    style = "Italic"

    [font.normal]
    family = "Iosevka Nerd Font"
    style = "Regular"

    [window]
    opacity = 0.85
    blur = true

    [scrolling]
    history = 20000
  '';
}
