{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";

    bansheedm2 = {
      url = "github:bansheerubber/bansheedm2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bansheefinder3 = {
      url = "github:bansheerubber/bansheefinder2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bansheeniri = {
      url = "github:bansheerubber/bansheeniri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bansheescripts = {
      url = "github:bansheerubber/bansheescripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fontdb-cache-loader = {
      url = "github:bansheerubber/fontdb-cache-loader";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polybar-watcher = {
      url = "github:bansheerubber/polybar-watcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:bansheerubber/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          modules = [ ./modules/systemd-boot.nix ];
          system = "x86_64-linux";
          type = "laptop";
        };
        bansheelittle = helpers.makeHost {
          hostname = "bansheelittle";
          modules = [ ./modules/rpi-boot.nix ];
          system = "aarch64-linux";
          type = "appliance";
        };
      };
    };
}
