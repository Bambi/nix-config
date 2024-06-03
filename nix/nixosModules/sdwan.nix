{ pkgs, ... }: {
  imports = [ ./nebula ];

  environment.systemPackages = [ pkgs.zerotierone ];
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "35c192ce9bffab7b" ];
  };
}
