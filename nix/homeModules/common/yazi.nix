{ inputs, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    settings = {
      manager = {
        show_hidden = false;
        ratio = [ 2 3 7 ];
      };
    };

    theme = {
      manager = {
        border_symbol = " ";
      };
    };

    plugins = {
      chmod = "${inputs.yazi-plugins}/chmod.yazi";
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
      smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
      starship = "${inputs.yazi-starship}";
    };

    initLua = ''
      require("starship"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [ "c" "m" ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "i";
          run = "shell '${pkgs.bat}/bin/bat --paging=always --color=always \"$0\"' --confirm --block";
          desc = "View file";
        }
        {
          on = "I";
          run = "shell '${pkgs.bat}/bin/bat --paging=always --color=always --decorations never \"$0\"' --confirm --block";
          desc = "View file without line numbers";
        }
        {
          on = "W";
          run = "shell '$SHELL --interactive' --confirm --block";
          desc = "Launch a working shell";
        }
      ];
    };
  };
}
