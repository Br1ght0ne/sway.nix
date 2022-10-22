{ name, src, stdenv, builtDependencies, lib, forc, rsync, release ? true
, locked ? true, offline ? false, ... }:

let
  forcBuildOptions = lib.optional release "--release" ++ lib.optional locked
    "--locked"
    # TODO: --offline doesn't work yet
    # ++ lib.optional offline "--offline"
  ;

  drvAttrs = {
    inherit name src builtDependencies forcBuildOptions;
    nativeBuildInputs = [ forc rsync ];

    configurePhase = ''
      log() {
          >&2 echo "[sway.nix]" "$@"
      }

      for dep in $builtDependencies; do
        log "pre-installing dep $dep"
        if [ -d "$dep/target" ]; then
          >&2 ${rsync}/bin/rsync -rl \
            --no-perms \
            --no-owner \
            --no-group \
            --chmod=+w \
            --executability $dep/target/ target
        fi
        if [ -d "$dep/.forc" ]; then
          >&2 ${rsync}/bin/rsync -rl \
            --no-perms \
            --no-owner \
            --no-group \
            --chmod=+w \
            --executability $dep/.forc/ .forc
        fi
      done

      log "building ${name} at ${src}"
      cp -rv ${src} ./src
    '';

    buildPhase = ''
      logRun() {
        >&2 echo "$@"
        eval "$@"
      }

      mkdir -p $out
      export HOME=$out

      runHook preBuild

      # TODO: --locked and --offline after deps are vendored/prefetched
      # TODO: passthrough other useful options?
      logRun ${forc}/bin/forc build --path src --output-directory out $forcBuildOptions

      runHook postBuild
    '';

    checkPhase = ''
      cd src
      ${forc}/bin/forc test
    '';

    installPhase = ''
      cp -rv out $out/out
    '';
  };
  drv = stdenv.mkDerivation drvAttrs; # TODO: // userAttrs
in drv
