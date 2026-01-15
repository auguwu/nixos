_: {
  programs.noelware.eousctl = {
    enable = true;
    settings = {
      daemons = {
        "us-west-1.eousd.noelware.org" = {
          name = "noelware-us-1";
          auth.scheme = "noelware";
          secure = true;
        };

        # This is the `eousd` instance hosted on `noel@hokkaido`
        "eous.noel.pink" = {
          name = "hokkaido";
          auth.scheme = "none";
          secure = true;
        };
      };
    };
  };
}
