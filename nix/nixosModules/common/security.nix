{ ... }: {
  # use doas instead-of sudo
  # security.sudo.enable = false;

  security = {
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
