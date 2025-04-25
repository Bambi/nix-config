{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      weekstart = "Monday";
      sync = {
        server = {
          url = "http://192.168.100.1:10222";
        };
      };
      uda.priority.values = "H,M,,L,h";
      urgency = {
        uda.priority = {
          L.coefficient = -1;
          h.coefficient = -20; # hold task
        };
        annotations.coefficient = 0.1;
        blocking.coefficient = 2;
        blocked.coefficient = -2;
      };
    };
    extraConfig = "include ~/.config/sops-nix/secrets/taskwarrior_sync";
  };
  home.packages = with pkgs; [ taskwarrior-tui ];
}
