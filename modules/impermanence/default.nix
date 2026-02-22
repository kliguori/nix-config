{ config, lib, ... }:
let
  cfg = config.systemOptions.impermanence;
in
{
  options.systemOptions.impermanence = {
    enable = lib.mkEnableOption "Impermanent root with persistence under /persist" // { default = true; };

    rootTmpfsSize = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "Optional tmpfs size";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "mode=0755"
          "size=${cfg.rootTmpfsSize}"
        ];
      };
      "/nix".neededForBoot = true;
      "/persist".neededForBoot = true;
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
      ];

      files = [
        "/etc/machine-id"
      ];
    };

    # Required for impermanence
    programs.fuse.userAllowOther = true;
  };
}
