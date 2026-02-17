{ unstablePkgs, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    dgop.package = unstablePkgs.dgop;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };
}
