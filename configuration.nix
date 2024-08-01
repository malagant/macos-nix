{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
  user = import "${homeDir}/.config/nix/user.nix";
in
{
  # Nix configuration ------------------------------------------------------------------------------
  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "${user.name}"
  ];

  nix.configureBuildUsers = true;

  nix.gc.automatic = true;
  nix.gc.options = "--max-freed $((25 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    build-users-group = nixbld
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableFzf = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      top_padding = 36;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };
    extraConfig = ''
      		yabai -m rule --add app='System Preferences' manage=off
    '';
  };

  services.sketchybar = {
    enable = true;
    config = ''
      		# This is a demo config to showcase some of the most important commands.
          # It is meant to be changed and configured, as it is intentionally kept sparse.
          # For a (much) more advanced configuration example see my dotfiles:
          # https://github.com/FelixKratz/dotfiles

          PLUGIN_DIR="$CONFIG_DIR/plugins"

          ##### Bar Appearance #####
          # Configuring the general appearance of the bar.
          # These are only some of the options available. For all options see:
          # https://felixkratz.github.io/SketchyBar/config/bar
          # If you are looking for other colors, see the color picker:
          # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

          sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000

          ##### Changing Defaults #####
          # We now change some default values, which are applied to all further items.
          # For a full list of all available item properties see:
          # https://felixkratz.github.io/SketchyBar/config/items

          default=(
            padding_left=5
            padding_right=5
            icon.font="Hack Nerd Font:Bold:17.0"
            label.font="Hack Nerd Font:Bold:14.0"
            icon.color=0xffffffff
            label.color=0xffffffff
            icon.padding_left=4
            icon.padding_right=4
            label.padding_left=4
            label.padding_right=4
          )
          sketchybar --default "$\{default[@]\}"

          ##### Adding Mission Control Space Indicators #####
          # Let's add some mission control spaces:
          # https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
          # to indicate active and available mission control spaces.

          SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
          for i in "$\{!SPACE_ICONS[@]\}"
          do
            sid="$(($i+1))"
            space=(
              space="$sid"
              icon="$\{SPACE_ICONS[i]\}"
              icon.padding_left=7
              icon.padding_right=7
              background.color=0x40ffffff
              background.corner_radius=5
              background.height=25
              label.drawing=off
              script="$PLUGIN_DIR/space.sh"
              click_script="yabai -m space --focus $sid"
            )
            sketchybar --add space space."$sid" left --set space."$sid" "$\{space[@]\}"
          done

          ##### Adding Left Items #####
          # We add some regular items to the left side of the bar, where
          # only the properties deviating from the current defaults need to be set

          sketchybar --add item chevron left \
                     --set chevron icon= label.drawing=off \
                     --add item front_app left \
                     --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
                     --subscribe front_app front_app_switched

          ##### Adding Right Items #####
          # In the same way as the left items we can add items to the right side.
          # Additional position (e.g. center) are available, see:
          # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

          # Some items refresh on a fixed cycle, e.g. the clock runs its script once
          # every 10s. Other items respond to events they subscribe to, e.g. the
          # volume.sh script is only executed once an actual change in system audio
          # volume is registered. More info about the event system can be found here:
          # https://felixkratz.github.io/SketchyBar/config/events

          sketchybar --add item clock right \
                     --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
                     --add item volume right \
                     --set volume script="$PLUGIN_DIR/volume.sh" \
                     --subscribe volume volume_change \
                     --add item battery right \
                     --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
                     --subscribe battery system_woke power_source_change

          ##### Force all scripts to run the first time (never do this in a script) #####
          sketchybar --update
            echo "sketchybar configuration loaded.."
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      ## Navigation (lalt - ...)
      # Space Navigation (four spaces per display): lalt - {1, 2, 3, 4}
      lalt - 1 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((1+4*($DISPLAY - 1)))
      lalt - 2 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((2+4*($DISPLAY - 1)))
      lalt - 3 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((3+4*($DISPLAY - 1)))
      lalt - 4 : DISPLAY="$(yabai -m query --displays --display | jq '.index')"; yabai -m space --focus $((4+4*($DISPLAY - 1)))

      # Window Navigation (through display borders): lalt - {j, k, l, ö}
      lalt - j    : yabai -m window --focus west  || yabai -m display --focus west
      lalt - k    : yabai -m window --focus south || yabai -m display --focus south
      lalt - l    : yabai -m window --focus north || yabai -m display --focus north
      lalt - 0x29 : yabai -m window --focus east  || yabai -m display --focus east

      # Extended Window Navigation: lalt - {h, ä}
      lalt -    h : yabai -m window --focus first
      lalt - 0x27 : yabai -m window --focus  last

      # Float / Unfloat window: lalt - space
      lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus

      # Make window zoom to fullscreen: shift + lalt - f
      shift + lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus

      # Make window zoom to parent node: lalt - f
      lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

      ## Window Movement (shift + lalt - ...)
      # Moving windows in spaces: shift + lalt - {j, k, l, ö}
      shift + lalt - j : yabai -m window --warp west || $(yabai -m window --display west && sketchybar --trigger windows_on_spaces && yabai -m display --focus west && yabai -m window --warp last) || yabai -m window --move rel:-10:0
      shift + lalt - k : yabai -m window --warp south || $(yabai -m window --display south && sketchybar --trigger windows_on_spaces && yabai -m display --focus south) || yabai -m window --move rel:0:10
      shift + lalt - l : yabai -m window --warp north || $(yabai -m window --display north && sketchybar --trigger windows_on_spaces && yabai -m display --focus north) || yabai -m window --move rel:0:-10
      shift + lalt - 0x29 : yabai -m window --warp east || $(yabai -m window --display east && sketchybar --trigger windows_on_spaces && yabai -m display --focus east && yabai -m window --warp first) || yabai -m window --move rel:10:0

      # Toggle split orientation of the selected windows node: shift + lalt - s
      shift + lalt - s : yabai -m window --toggle split

      # Moving windows between spaces: shift + lalt - {1, 2, 3, 4, p, n } (Assumes 4 Spaces Max per Display)
      shift + lalt - 1 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((1+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 2 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((2+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 3 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((3+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - 4 : DISPLAY="$(yabai -m query --displays --display | jq '.index')";\
                        yabai -m window --space $((4+4*($DISPLAY - 1)));\
                        sketchybar --trigger windows_on_spaces

      shift + lalt - p : yabai -m window --space prev; yabai -m space --focus prev; sketchybar --trigger windows_on_spaces
      shift + lalt - n : yabai -m window --space next; yabai -m space --focus next; sketchybar --trigger windows_on_spaces

      # Mirror Space on X and Y Axis: shift + lalt - {x, y}
      shift + lalt - x : yabai -m space --mirror x-axis
      shift + lalt - y : yabai -m space --mirror y-axis

      ## Stacks (shift + ctrl - ...)
      # Add the active window to the window or stack to the {direction}: shift + ctrl - {j, k, l, ö}
      shift + ctrl - j    : yabai -m window  west --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - k    : yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - l    : yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus
      shift + ctrl - 0x29 : yabai -m window  east --stack $(yabai -m query --windows --window | jq -r '.id'); sketchybar --trigger window_focus

      # Stack Navigation: shift + ctrl - {n, p}
      shift + ctrl - n : yabai -m window --focus stack.next
      shift + ctrl - p : yabai -m window --focus stack.prev

      ## Resize (ctrl + lalt - ...)
      # Resize windows: ctrl + lalt - {j, k, l, ö}
      ctrl + lalt - j    : yabai -m window --resize right:-100:0 || yabai -m window --resize left:-100:0
      ctrl + lalt - k    : yabai -m window --resize bottom:0:100 || yabai -m window --resize top:0:100
      ctrl + lalt - l    : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
      ctrl + lalt - 0x29 : yabai -m window --resize right:100:0 || yabai -m window --resize left:100:0

      # Equalize size of windows: ctrl + lalt - e
      ctrl + lalt - e : yabai -m space --balance

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # Enable / Disable gaps in current workspace: ctrl + lalt - g
      ctrl + lalt - b : yabai -m config window_border off
      shift + ctrl + lalt - b : yabai -m config window_border on

      ## Insertion (shift + ctrl + lalt - ...)
      # Set insertion point for focused container: shift + ctrl + lalt - {j, k, l, ö, s}
      shift + ctrl + lalt - j : yabai -m window --insert west
      shift + ctrl + lalt - k : yabai -m window --insert south
      shift + ctrl + lalt - l : yabai -m window --insert north
      shift + ctrl + lalt - 0x29 : yabai -m window --insert east
      shift + ctrl + lalt - s : yabai -m window --insert stack

      ## Misc
      # Open new Alacritty window
      lalt - t : alacritty msg create-window

      # New window in hor./ vert. splits for all applications with yabai
      lalt - s : yabai -m window --insert east;  skhd -k "cmd - n"
      lalt - v : yabai -m window --insert south; skhd -k "cmd - n"

      # Toggle sketchybar
      shift + lalt - space : sketchybar --bar hidden=toggle
      shift + lalt - r : sketchybar --remove '/.*/' && sh -c '$HOME/.config/sketchybar/sketchybarrc'

      # Toggle margin of sketchybar
      shift + lalt - m : CURRENT="$(sketchybar --query bar | jq -r '.y_offset')"; \
                        if [ "$CURRENT" -eq "0" ]; then \
                          yabai -m config external_bar all:49:0; \
                          sketchybar --animate sin 15 --bar margin=10 y_offset=10 corner_radius=9; \
                        else \
                          yabai -m config external_bar all:39:0; \
                          sketchybar --animate sin 15 --bar margin=0 y_offset=0 corner_radius=0; \
                        fi \
    '';
  };

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    luarocks
    nmap
    alacritty
    docker
    docker-compose
    git
    grafana
    iterm2
    kitty
    lua
    neovim
    podman
    podman-compose
    podman-tui
    raycast
    vim
    wezterm
    wget
  ];

  # https://github.com/nix-community/home-manager/issues/423
  programs.nix-index.enable = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  users.users.${user.name}.home = "${user.homeDir}";
}
