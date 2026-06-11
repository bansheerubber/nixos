{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";

    bansheedm2.url = "github:bansheerubber/bansheedm2";
    bansheefinder3.url = "github:bansheerubber/bansheefinder2";
    bansheeniri.url = "github:bansheerubber/bansheeniri";
    bansheescripts.url = "github:bansheerubber/bansheescripts";
    fontdb-cache-loader.url = "github:bansheerubber/fontdb-cache-loader";
    polybar-watcher.url = "github:bansheerubber/polybar-watcher";
    waybar.url = "github:bansheerubber/Waybar";
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
          # type = "appliance";
          type = "laptop";
        };
      };
    };
}
