let
  lanNetwork = "192.168.0";
in
{
  hosts = {
    popeye = {
      interfaces = [
        {
          mac = "84:7b:eb:1e:eb:d8";
          addr = "${lanNetwork}.1";
        }
        {
          mac = "9c:24:72:ab:d1:90";
          addr = "176.177.24.32";
        }
      ];
    };
    babar = {
      interfaces = [
        {
          mac = "00:4e:01:9f:2d:74";
          addr = "${lanNetwork}.2";
        }
      ];
    };
    pCP = {
      interfaces = [
        {
          mac = "b8:27:eb:6c:7b:54";
          addr = "${lanNetwork}.3";
        }
      ];
    };
  };
  publicIp = "176.177.24.32";
  # wanMacAddr = 
}
