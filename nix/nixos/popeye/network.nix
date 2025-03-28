network: {
  hosts = [
    {
      Name = "popeye";
      Address = "${network}.1";
      MACAddress = "84:7b:eb:1e:eb:d8";
    }
    {
      Name = "babar";
      Address = "${network}.2";
      MACAddress = "00:4e:01:9f:2d:74";
    }
    {
      Name = "pCP";
      Address = "${network}.3";
      MACAddress = "b8:27:eb:6c:7b:54";
    }
  ];
}
