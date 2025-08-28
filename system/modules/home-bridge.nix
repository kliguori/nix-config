{ lib, config, inputs, homePath, ... }:
let
  mkIf = lib.mkIf;
  hm   = config.my.home;
  p    = config.my.profile;
  hmProfile = hm.profileOverride or p;
in
{
  imports = mkIf hm.manage [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf hm.manage {
    home-manager.users = lib.genAttrs hm.users (user: {
      imports = [
        (homePath + "/profiles/${hmProfile}.nix")
        # add extra HM modules if you like, e.g.:
        # (homePath + "/modules/neovim.nix")
      ];
      home.username = user;
      home.homeDirectory = "/home/${user}";
      programs.home-manager.enable = true;
    });
  };
}
