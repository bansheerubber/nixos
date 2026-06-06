{
  config,
  lib,
  pkgs,
  type,
  ...
}:
let
  waybar-jsonc = pkgs.writeText "waybar.jsonc" ''
    {
    	"height": 32,
    	"spacing": 10,
    	"modules-left": [],
    	"modules-center": [
    		"clock",
    	],
    	"modules-right": [
    		"custom/chargerate",
    		"battery",
    	],
    	"clock": {
    		"format": "{:%A %d %b, %I:%M %p}",
    		"tooltip": false,
    	},
    	"battery": {
    		"bat": "BAT1",
    		"format": "{capacity}%",
    	},
    	"custom/chargerate": {
    		"exec": "$HOME/.local/scripts/charge-rate.sh",
    		"interval": 10,
    	},
    }

  '';
  waybar-css = pkgs.writeText "waybar.css" ''
    * {
    	font-family: 'Ttyp0 OTB';
    	font-size: 20px;
    	color: #B7ACB7
    }

    window#waybar {
    	background-color: #1E121E;
    }

    #battery {
    	padding-right: 4px;
    }

    #workspaces button {
    	min-width: 0px;
    	padding: 0px 8px;
    	border-radius: 0px;
    	border: none;
    }

    #workspaces button.focused,
    #workspaces button.focused:hover,
    #workspaces button.active,
    #workspaces button.active:hover {
    	background-color: #322238;
    }

    #workspaces button.urgent {
    	background-color: #BD2C40;
    }

    #workspaces button:hover {
    	background: none;
    	box-shadow: inherit;
    	text-shadow: inherit;
    	transition: none;
    }

    #mode {
    	background-color: #FFEE5E;
    	color: #1E121E;
    	padding: 0px 5px;
    	margin-left: 2px;
    }

    #image {
    	margin-top: 0px;
    }
  '';
  start-waybar = pkgs.writeScript "start-waybar.sh" ''
    #!/bin/env bash
    exec waybar -c ${waybar-jsonc} -s ${waybar-css} &> /dev/null
  '';
  swayConfig = pkgs.writeText "sway-config" ''
    include /etc/sway/config.d/*

    input type:keyboard xkb_numlock enabled

    # brightness commands
    bindsym XF86MonBrightnessUp exec brightnessctl set 20%+
    bindsym XF86MonBrightnessDown exec brightnessctl set 20%-
    bindsym Shift+XF86MonBrightnessUp exec brightnessctl set 2.5%+
    bindsym Shift+XF86MonBrightnessDown exec brightnessctl set 2.5%-
    bindsym Mod1+XF86MonBrightnessUp exec brightnessctl set 100%
    bindsym Mod1+XF86MonBrightnessDown exec brightnessctl set 0%

    exec wlsunset -t 4000 -T 4001 -d 0
    exec swaybg -m fill -i /etc/greetd/background.png
    exec bansheedm2

    bar {
      swaybar_command ${start-waybar}
    }
  '';
in
{
  services.greetd =
    if (type == "laptop") then
      {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.sway}/bin/sway --config ${swayConfig} 2> /dev/null";
          };
        };
      }
    else
      {
        enable = true;
        settings = {
          default_session = {
            command = "${config.programs.niri.package}/bin/niri-session";
            user = "me";
          };
        };
      };
}
