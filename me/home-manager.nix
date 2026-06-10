{
  osConfig,
  ...
}:
let
  hostname = osConfig.networking.hostName;
in
{
  home = {
    username = "me";
    homeDirectory = "/home/me";
    stateVersion = "26.05";
  };

  xdg.configFile = {
    # niri
    "niri/config.kdl".source = ./configs/niri/config.kdl;
    "niri/binds.kdl".source = ./configs/niri/binds.kdl;
    "niri/outputs.kdl".source = ./configs/niri/outputs.kdl;
    "niri/workspaces.kdl".source = ./configs/niri/workspaces.kdl;

    # alacritty
    "alacritty/alacritty.toml".source = ./configs/alacritty/alacritty.toml;

    # waybar
    "waybar/config.base.jsonc".source = ./configs/waybar/config.${hostname}.base.jsonc;
    "waybar/config.jsonc".source = ./configs/waybar/config.${hostname}.jsonc;
    "waybar/style.css".source = ./configs/waybar/style.${hostname}.css;
  };

  xdg.configFile."nvim" = {
    source = ./configs/nvim;
    recursive = true;
  };

  home.file.".themes/bansheetheme" = {
    source = ./configs/themes/bansheetheme;
    recursive = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      stty -ixon
      shopt -s autocd

      alias ls='ls --color=auto'
      alias grep='grep --color=auto'

      export EDITOR=nvim
      export SUDO_EDITOR=nvim

      export HISTSIZE=-1

      if [ -n "$SSH_CLIENT" ]; then
        export XDG_RUNTIME_DIR=/run/user/$(id -u me)
        export PS1="\u@\H \w/ >> "
      elif [ "$SHLVL" -ge 4 ]; then
        export PS1="\u \w/ << "
      else
        export PS1="\u \w/ >> "
      fi

      function cd () {
        builtin cd "$@"
        if test -f .bansheerc; then
          source .bansheerc
        fi
      }

      function cdp () {
        cd /home/me/Projects/$@
      }

      if [ "$SHLVL" -lt 4 ]; then
        if test -f .bansheerc; then
          source .bansheerc
        fi
      fi
    '';
  };

  gtk = {
    enable = true;

    theme = {
      name = "bansheetheme";
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  programs.home-manager.enable = true;
}
