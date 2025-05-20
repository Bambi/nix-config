lib:
let
  lanNetwork = "192.168.0";
in
rec {
  hosts = {
    bambi = {
      interfaces = {
        "${lanNetwork}.254" = {
          mac = "84:7b:eb:1e:eb:d8";
          usage = "lan";
          ip6 = "2001:861:5e61:5d9d:207:32ff:fe57:926c";
        };
        "176.177.24.32" = {
          mac = "9c:24:72:ab:d1:90";
          usage = "wan";
          ip6 = "2001:861:5e61:5d9f:9e24:72ff:feab:d190";
        };
        "192.168.1.254" = {
          mac = "00:c0:ca:b5:61:65";
          usage = "wlan";
          ip6 = "2001:861:5e61:5d9e:2c0:caff:feb5:6165";
        };
      };
    };
    babar = {
      interfaces = {
        "${lanNetwork}.2" = {
          mac = "00:4e:01:9f:2d:74";
        };
      };
    };
    pCP = {
      interfaces = {
        "${lanNetwork}.3" = {
          mac = "b8:27:eb:6c:7b:54";
        };
      };
    };
  };
  lan = {
    cidrv4 = "${lanNetwork}.0/24";
    gw = "${lanNetwork}.254";
    mask = 24;
  };
  publicIP = "176.177.24.32";
  hostItfList = hostName:
    let
      namedItfs = lib.attrsets.mapAttrs (n: v: v // { addr = n; }) hosts.${hostName}.interfaces;
    in
    lib.attrsets.mapAttrsToList (_: v: v) namedItfs;
  lighthouseItf = { addr = "192.168.100.1"; };
  wanMacAddr = hosts.bambi.interfaces."${publicIP}".mac;
  nebulaBindIps = lib.attrsets.mapAttrsToList (n: _: "${n}:4242") hosts.bambi.interfaces
    ++ lib.attrsets.mapAttrsToList (_: v: "[${v.ip6}]:4242") hosts.bambi.interfaces;
}
