{ ... }:
{
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      mru-spaces = false; # Don't rearrange spaces based on recent use
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true; 
      _FXShowPosixPathInTitle = true; # Show full path in title
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true; 
      TrackpadRightClick = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15; 
      KeyRepeat = 2; 
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false; 
      "com.apple.swipescrolldirection" = false; # Natural scrolling off
    };
  };
}
