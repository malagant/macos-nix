{ pkgs, ... }:
{
		programs.tmux = {
			enable = true;
			keyMode = "vi";
			baseIndex = 1;
			customPaneNavigationAndResize = true;
			extraConfig = ''
			  unbind r
				bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."
				set-option -g mouse on
				set -g prefix C-a
				set -ga terminal-overrides ",xterm-256color:Tc"
			'';

			plugins = with pkgs; [
			  tmuxPlugins.battery
				{
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
				{
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
			];
		};
	}
