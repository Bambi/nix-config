{ pkgs, bootTheme ? "circle", ... }: {
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    plymouth = {
      enable = true;
      theme = bootTheme;
      themePackages = with pkgs; [ plymouth-circle plymouth-colorful_loop plymouth-cuts ];
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
    };
  };
}
