{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      weekstart = "Monday";
    };
  };
  home.packages = with pkgs; [ taskwarrior-tui ];
}
