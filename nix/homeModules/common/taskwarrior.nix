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
      uda.priority.values = "H,M,,L";
      urgency.uda.priority.L.coefficient = -0.5;
    };
    extraConfig = "include ~/.config/sops-nix/secrets/taskwarrior_sync";
  };
  home.packages = with pkgs; [ taskwarrior-tui ];
}
