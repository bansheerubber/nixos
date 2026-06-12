{
  home-manager,
  inputs,
  nixpkgs,
}:

{
  makeHost =
    {
      hostname,
      modules,
      system,
      type,
    }:
    nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs;
        hostname = hostname;
        type = type;
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
      ] ++ modules;
    };
}
