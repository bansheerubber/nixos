{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";

    bansheedm2.url = "git+file:/home/me/Projects/bansheedm2";
    bansheefinder3.url = "git+file:/home/me/Projects/bansheefinder3";
    bansheeniri.url = "git+file:/home/me/Projects/bansheeniri";
    bansheescripts.url = "git+file:/home/me/Projects/bansheescripts";
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
      helpers = (
        import ./helpers.nix {
          home-manager = home-manager;
          inputs = inputs;
          nixpkgs = nixpkgs;
        }
      );
    in
    {
      nixosConfigurations = {
        bansheerubber = helpers.makeHost {
          hostname = "bansheerubber";
          system = "x86_64-linux";
          type = "laptop";
        };
        bansheelittle = helpers.makeHost {
          hostname = "bansheelittle";
          system = "aarch64-linux";
          type = "appliance";
        };
      };
    };
}
