{
  description = "Build Sway projects with Nix";

  inputs = {
    fuel-nix.url = "github:FuelLabs/fuel.nix";
    nixpkgs.follows = "fuel-nix/nixpkgs";
    utils.follows = "fuel-nix/utils";
  };

  outputs = { self, fuel-nix, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        lib = pkgs.callPackage ./default.nix {
          inherit (fuel-nix.packages.${system}) forc;
        };
        # packages = flake-utils.lib.flattenTree {
        #   hello = pkgs.hello;
        #   gitAndTools = pkgs.gitAndTools;
        # };
        # defaultPackage = packages.hello;
        # apps.hello = flake-utils.lib.mkApp { drv = packages.hello; };
        # defaultApp = apps.hello;
      });
}
