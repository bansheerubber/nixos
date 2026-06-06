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
