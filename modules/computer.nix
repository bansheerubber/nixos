{
  inputs,
  lib,
  pkgs,
  type,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    lib.mkMerge [
      (lib.mkIf (type == "laptop" || type == "desktop") [
        inputs.bansheefinder3.packages.${pkgs.stdenv.hostPlatform.system}.default
        chromium
        kdePackages.okular
        libreoffice
        mpv
        qbittorrent
        qbittorrent-cli
        texstudio
        thunar
        thunar-archive-plugin
        thunar-volman
        vlc
        vscode
      ])

      (lib.mkIf
        ((type == "laptop" || type == "desktop") && pkgs.stdenv.hostPlatform.system == "x86_64-linux")
        [
          blender
          gitkraken
          obs-cmd
          obs-studio
          steam
        ]
      )
    ];
}
