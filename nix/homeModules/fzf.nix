{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border"
    ];
  };
  home.sessionVariables = {
    FZF_CTRL_R_OPTS = "--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'";
  };
}
