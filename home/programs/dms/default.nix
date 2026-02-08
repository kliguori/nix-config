{ ... }:
{
  programs.dank-material-shell = {
    enable = true;

    enableClipboard = true;
    enableSystemMonitoring = true;
    enableNotifications = true;
    enableLauncher = true;
    enableScreenshot = true;
    enableBluetooth = true;
    enableNetwork = true;
    enableAudio = true;
    enableBrightness = true;
    enablePolkit = true;
    enableIdleInhibit = true;

    defaultSession = "niri";
  };
}
