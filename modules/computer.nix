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
        qbittorrent
        qbittorrent-cli
        texstudio
        thunar
        thunar-archive-plugin
        thunar-volman
        vlc
        vscode
      ])

      (lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
        blender
        gitkraken
        obs-cmd
        obs-studio
        steam
      ])
    ];
}
