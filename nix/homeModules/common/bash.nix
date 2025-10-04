{ config, lib, ... }: {
  config = lib.mkIf config.my.bash {
    programs.bash = {
      enable = true;
      historyControl = [ "ignoredups" ];
      historyFileSize = 4000;
      shellAliases = { };
    };
  };
}
