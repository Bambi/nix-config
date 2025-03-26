network: {
  hosts = [
    {
      Name = "popeye";
      Address = "${network}.10";
      MACAddress = "84:7b:eb:1e:eb:d8";
    }
    {
      Name = "babar";
      Address = "${network}.11";
      MACAddress = "00:4e:01:9f:2d:74";
    }
  ];
}
