{ name, src, stdenv, lib, forc }:

let
  # TODO: --locked and --offline after deps are vendored/prefetched
  # TODO: passthrough other useful options?
  buildCommand = "forc build --release";
  drvAttrs = {
    inherit name src;
    nativeBuildInputs = [ forc ];

    buildPhase = ''
      mkdir home
      export HOME=$PWD/home

      runHook preBuild

      ${buildCommand}

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/out/release
      cp -v out/release/* $out/out/release
    '';
  };
  drv = stdenv.mkDerivation drvAttrs; # TODO: // userAttrs
in drv
