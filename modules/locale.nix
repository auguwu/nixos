_: let
  locale = "en_GB.UTF-8";
  timeZone = "America/Los_Angeles";
in {
  time.timeZone = timeZone;
  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = locale;
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = locale;
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = locale;
    };
  };
}
