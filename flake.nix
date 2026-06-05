{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";

    bansheedm2.url = "git+file:/home/me/Projects/bansheedm2";
    bansheefinder3.url = "git+file:/home/me/Projects/bansheefinder3";
    bansheeniri.url = "git+file:/home/me/Projects/bansheeniri";
    fontdb-cache-loader.url = "git+file:/home/me/Projects/fontdb-cache-loader";
    polybar-watcher.url = "git+file:/home/me/Projects/polybar-watcher";
    waybar.url = "git+file:/home/me/Projects/Waybar";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      nixosConfigurations.bansheerubber = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostname = "bansheerubber";
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.me = ./me/home-manager.nix;
            };
          }
        ];
      };
    };
}
