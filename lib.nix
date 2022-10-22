{ lib }:

{
  readForcTOML = tomlPath: (lib.trivial.importTOML tomlPath);
}
