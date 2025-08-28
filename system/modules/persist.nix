{ lib, config, pkgs, ... }:
let
  mkIf = lib.mkIf;
  helpers = import ../../lib/tmpfiles.nix { inherit lib; };
  persistRoot = config.my.persist.root;
in
{
  assertions = lib.optional (config.my.persist.enable) {
    assertion = persistRoot != "/";
    message = "my.persist.root must not be '/'.";
  };

  # Ensure directories exist with correct perms
  systemd.tmpfiles.rules =
    mkIf config.my.persist.enable
      (helpers.mkDirsRules ([
        { path = persistRoot; mode = "0755"; }
      ] ++ config.my.persist.paths));

  # Bind mount each persisted path from persist root
  fileSystems = mkIf config.my.persist.enable
    (lib.listToAttrs (map (p:
      let target = p.path;
          source = "${persistRoot}${p.path}";
      in {
        name = target;
        value = {
          device = source;
          fsType = "none";
          options = [ "bind" ];
          neededForBoot = true;
        };
      }) config.my.persist.paths));
}
