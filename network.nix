lib:
let
  lanNetwork = "192.168.0";
in
rec {
  hosts = {
    popeye = {
      interfaces = {
        "${lanNetwork}.1" = {
          mac = "84:7b:eb:1e:eb:d8";
        };
        "176.177.24.32" = {
          mac = "9c:24:72:ab:d1:90";
        };
        "192.168.100.1" = {
          isLighthouse = true;
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
  hostItfList = hostName:
    let
      namedItfs = lib.attrsets.mapAttrs (n: v: v // { addr = n; }) hosts.${hostName}.interfaces;
    in
    lib.attrsets.mapAttrsToList (n: v: v) namedItfs;
  lighthouseItf = host: lib.lists.findFirst (x: builtins.hasAttr "isLighthouse" x) { addr = null; } (hostItfList host);
  publicIp = "176.177.24.32";
  wanMacAddr = hosts.popeye.interfaces."${publicIp}".mac;
}
