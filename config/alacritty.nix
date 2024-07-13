{
  home.file.".config/alacritty/alacritty.toml".text = ''
    import = [
      "~/.config/alacritty/themes/themes/tokyo-night.toml"
    ]

    [font]
    size = 16.0

    [font.bold]
    family = "JetBrainsMonoNL Nerd Font"
    style = "Bold"

    [font.bold_italic]
    family = "JetBrainsMonoNL Nerd Font"
    style = "Bold Italic"

    [font.italic]
    family = "JetBrainsMonoNL Nerd Font"
    style = "Italic"

    [font.normal]
    family = "JetBrainsMonoNL Nerd Font"
    style = "Regular"

    [window]
    opacity = 0.85
    blur = true
  '';
}
