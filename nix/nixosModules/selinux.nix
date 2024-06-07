{ pkgs, ... }: {
  # Linux Kernel
  boot.kernelParams = [
    "security=selinux"
  ];
  boot.kernelPatches = [{
    name = "selinux-config";
    patch = null;
    extraConfig = '' 
      SECURITY_SELINUX y
      SECURITY_SELINUX_BOOTPARAM n
      SECURITY_SELINUX_DEVELOP y
      SECURITY_SELINUX_AVC_STATS y
      DEFAULT_SECURITY_SELINUX n
    '';
  }];

  systemd.package = pkgs.systemd.override { withSelinux = true; };

  environment.systemPackages = with pkgs; [
    policycoreutils
  ];
}
