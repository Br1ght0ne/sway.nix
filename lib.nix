{ lib, runCommand, forc }:

rec {
  readForcTOML = tomlPath: (lib.trivial.importTOML tomlPath);

  dummyForcProjectWithDeps = prevProjectPath:
    let
      prevForcTOML = readForcTOML "${prevProjectPath}/Forc.toml";
      name = "${prevForcTOML.project.name}-deps";
    in runCommand name { } ''
      mkdir -p $out
      export HOME=$out

      echo "pre forc init"
      ${forc}/bin/forc init --name ${name} --path $out
      # TODO: Forc.lock and --locked for deps
      cp -v ${prevProjectPath}/Forc.{toml,lock} $out
    '';
}
