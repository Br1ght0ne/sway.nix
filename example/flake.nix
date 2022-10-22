{
  description = "A basic flake for a Sway project";

  inputs = {
    sway-nix.url = "../.";
    nixpkgs.follows = "sway-nix/nixpkgs";
    utils.follows = "sway-nix/utils";
  };

  outputs = { self, sway-nix, nixpkgs, utils }:
    utils.lib.eachDefaultSystem
    (system: { packages.default = sway-nix.lib.${system}.buildPackage ./.; });
}
