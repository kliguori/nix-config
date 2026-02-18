{ config, lib, ... }:
let
  cfg = config.systemOptions.hibernate;
in
{
  options.systemOptions.hibernate = {
    enable = lib.mkEnableOption "Hibernate and suspend support";
    resumeDevice = lib.mkOption {
      type = lib.types.str;
      description = "Path to the swap device to use for hibernation";
    };
    delaySec = lib.mkOption {
      type = lib.types.str;
      default = "30min";
      description = "Time before hibernate.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [ 
      "resume=${cfg.resumeDevice}"
      "hibernate.mode=shutdown"
    ];
    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowSuspendThenHibernate=yes
      HibernateDelaySec=${cfg.delaySec}
    '';
  };
}
