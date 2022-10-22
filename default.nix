{ lib, stdenv, forc }@defaultBuildAttrs:

let
  libb = import ./lib.nix { inherit lib; };
  buildPackage = src:
    let
      forcTOML = libb.readForcTOML "${src}/Forc.toml";
      name = forcTOML.project.name;
      build = args:
        import ./build.nix ({
          # TODO: config build args
        } // defaultBuildAttrs // args);
      # TODO: buildDeps
      buildTopLevel = let drv = build { inherit name src stdenv; }; in drv;
    in buildTopLevel;
in { inherit buildPackage; }
