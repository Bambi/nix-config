{ pkgs, inputs, ... }: {
  services.unbound = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      server = {
        interface = "127.0.0.1@5353";
        access-control = [ "127.0.0.1/0 allow" ];
        verbosity = 1;
      };
      include = "/etc/unbound/blocklist";
      remote-control.control-enable = true;
    };
  };
  environment.etc."unbound/blocklist".source = "${inputs.unbound-block-list}/unbound/pro.blacklist.conf";
}
