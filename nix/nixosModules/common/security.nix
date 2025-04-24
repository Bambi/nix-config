_: {
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    doas = {
      enable = true;
      # extraRules = [{
      #   users = ["as"];
      #   keepEnv = true;
      #   persist = true;
      # }];
    };
  };
}
