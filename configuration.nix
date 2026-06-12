{
  hostname,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./greetd.nix
    ./modules/computer.nix
    ./modules/laptop.nix
  ];

  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
      "nowatchdog"
      "nmi_watchdog=0"
    ];

    consoleLogLevel = 3;
    blacklistedKernelModules = [ "sp5100_tco" "watchdog" ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1   localhost
    127.0.0.1   host.docker.internal

    # desk's lan
    10.0.0.1    bansheerubber
    10.0.0.2    bansheestorage
    10.0.0.3    bansheelong
    10.0.0.4    bansheestation
    10.0.0.5    bansheeair
    10.0.0.6    gitkraken

    # house WAN
    10.1.1.5    bansheelong-alt
    10.1.1.18   bansheedeck
    10.1.1.20   bansheestorage-alt
    10.1.1.21   bansheeipusb
    10.1.1.25   gitkraken-alt
    10.1.1.45   bansheephone
    10.1.1.83   bansheerubber-alt
    10.1.1.135  bansheekitchen
    10.1.1.166  bansheestation-alt
    10.1.1.194  network-tester
    10.1.1.196  bansheebox
    10.1.1.200  bansheetelevision
    10.1.1.201  remarkable
    10.1.1.239  bansheelittle
  '';

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."me" = {
    isNormalUser = true;
    description = "me";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.groups.nixos = {
    members = [
      "me"
      "root"
    ];
  };

  systemd.tmpfiles.settings = {
    "etc-nixos-group" = {
      "/etc/nixos" = {
        z = {
          mode = "0775";
          user = "root";
          group = "nixos";
        };
      };
      "/etc/nixos/*" = {
        Z = {
          mode = "0775";
          user = "root";
          group = "nixos";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    # CLI utils
    bat
    curl
    inotify-tools
    killall
    rsync
    stress
    unzip
    usbutils
    wget

    # desktop
    inputs.bansheedm2.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.bansheeniri.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.bansheescripts.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.fontdb-cache-loader.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.polybar-watcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default
    adwaita-fonts
    adwaita-icon-theme
    blueman
    bluez
    brightnessctl
    kdePackages.breeze
    mako
    playerctl
    pulseaudio
    sway
    swaybg
    swayidle
    swaylock
    wl-clip-persist
    wlsunset
    xwayland-satellite
    xfconf

    # dev
    gcc
    git
    go
    nixfmt
    nodejs
    python3
    rustup
    tree-sitter

    # programs
    alacritty
    feh
    firefox
    htop
    neovim
    nmgui
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      liberation_ttf
      mplus-outline-fonts.githubRelease
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      proggyfonts
      uw-ttyp0
    ];
  };

  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };
  systemd.user.services.niri.enableDefaultPath = false;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fmt
      glib
      libGL
      libX11
      libXcursor
      libXi
      libXrandr
      libxkbcommon
      stdenv.cc.cc
      stdenv.cc.cc.lib
      vulkan-loader
      wayland
      zlib
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  services.upower.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.blueman.enable = true;

  services.gvfs.enable = true;
  services.envfs.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    enableAllFirmware = true;
    enableAllHardware = true;

    keyboard.qmk.enable = true;

    uinput.enable = true;

    wooting.enable = true;
  };

  system.stateVersion = "26.05";
}
