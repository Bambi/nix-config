{ pkgs, ... }: {

  xdg.configFile."lf/icons".source = ./icons;
  xdg.configFile."lf/colors".source = ./colors;

  programs.lf = {
    enable = true;
    settings = {
      icons = true;
      preview = true;
      scrolloff = 5;
    };
    previewer.source = "${pkgs.pistol}/bin/pistol";
    commands = {
      open = ''''$${pkgs.ranger}/bin/rifle "$f"'';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
    };
    keybindings = {
      v = ''''$${pkgs.bat}/bin/bat --paging=always "$f"'';
      c = "mkdir";
      "." = "set hidden!";
      "<enter>" = "open";
    };
  };

}
