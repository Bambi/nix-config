_: {
  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    bantime = "12h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "384h"; # Do not ban for more than 2 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}
