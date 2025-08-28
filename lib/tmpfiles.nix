{ lib }:
let
  mkDir = { path, mode ? "0755", user ? "root", group ? "root" }:
    "d ${path} ${mode} ${user} ${group} -";
in
{
  mkDirsRules = dirs: builtins.map mkDir dirs;
}
