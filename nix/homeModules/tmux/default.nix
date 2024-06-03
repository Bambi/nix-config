{ config, pkgs, ... }: {
  home = {
    packages = [ pkgs.tmux ];
    sessionVariables = {
      FZF_TMUX_OPTS = "-p";
    };
  };

  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  xdg.configFile."tmux/tmux.conf.local".source = ./tmux.conf.local;
}
