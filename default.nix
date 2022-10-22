{ lib, stdenv, runCommand, forc, naersk, rsync }@defaultBuildAttrs:

let
  libb = import ./lib.nix { inherit lib runCommand forc; };
  buildPackage = src:
    let
      forcTOML = libb.readForcTOML "${src}/Forc.toml";
      name = forcTOML.project.name;
      build = args:
        import ./build.nix ({
          # TODO: config build args
        } // defaultBuildAttrs // args);
      # TODO: buildDeps

      buildDeps = build {
        name = "${name}-deps";
        src = libb.dummyForcProjectWithDeps src;
        inherit stdenv;
        builtDependencies = [ ];
      };
      buildRust = naersk.buildPackage {
        inherit src;
        compressTarget = false;
        copyTarget = true;
      };
      buildTopLevel = let
        drv = build {
          inherit name src stdenv;
          builtDependencies = [ buildDeps buildRust ];
          offline = true;
        };
      in drv;
    in buildTopLevel;
in { inherit buildPackage; }
