{ inputs, config, pkgs, ... }:
let api_uri = "[::]:8081";
in
{
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
    inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer
  ];

  services = {
    crowdsec = {
      enable = true;
      enrollKeyFile = "${config.sops.secrets.crowdsec_key.path}";
      allowLocalJournalAccess = true;
      settings = {
        common.log_level = "error";
        api.server = {
          listen_uri = api_uri;
        };
      };
      acquisitions = [
        {
          source = "journalctl";
          journalctl_filter = ["_SYSTEMD_UNIT=sshd.service"];
          labels.type = "syslog";
        }
      ];
    };
    crowdsec-firewall-bouncer = {
      enable = true;
      settings = {
        api_key = "N9NWI9y5CMcunRSEshypi/1S2OLP8+m39d40oanxVhs";
        api_url = "http://${api_uri}";
        update_frequency = "1m";
      };
    };
  };

  sops.secrets.crowdsec_key = {
    owner = "crowdsec";
    mode = "0400";
  };

  systemd.services.crowdsec.serviceConfig = {
    ExecStartPre = let
      script = pkgs.writeScriptBin "register-linux" ''
        #!${pkgs.runtimeShell}
        set -eu
        set -o pipefail

        if ! cscli bouncers list | grep -q "caddy"; then
          cscli bouncers add caddy --key "$(cat ${config.sops.secrets.crowdsec_apik.path}| cut -d' ' -f 2)"
        fi
        if ! cscli collections list | grep -q "linux"; then
          cscli collections install "crowdsecurity/linux"
        fi
      '';
    in ["${script}/bin/register-linux"];
  };
}
