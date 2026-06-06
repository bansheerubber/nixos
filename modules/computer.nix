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
    lib.mkIf (type == "laptop" || type == "desktop") [
      inputs.bansheefinder3.packages.${pkgs.system}.default
      blender
      chromium
      gitkraken
      kdePackages.okular
      libreoffice
      obs-cmd
      obs-studio
      qbittorrent
      qbittorrent-cli
      steam
      texstudio
      thunar
      thunar-archive-plugin
      thunar-volman
      vlc
      vscode
    ];
}
