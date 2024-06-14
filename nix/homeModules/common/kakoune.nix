{ pkgs, ... }: {
  programs.kakoune = {
    enable = true;
    plugins = with pkgs.kakounePlugins; [
      fzf-kak
      kakoune-buffers
      powerline-kak
      connect-kak
      prelude-kak
    ];
    config = {
      indentWidth = 4;
      tabStop = 4;
      scrollOff = {
        columns = 4;
        lines = 4;
      };
      showMatching = true;
      colorScheme = "gruvbox-dark";
      keyMappings = [
        { key = "D"; mode = "normal"; effect = "<a-l>d"; docstring = "delete to end of line"; }
        { key = "Y"; mode = "normal"; effect = "<a-l>y"; docstring = "yank to end of line"; }
        { key = "="; mode = "normal"; effect = ":format<ret>"; docstring = "format buffer"; }
        { key = "'#'"; mode = "normal"; effect = ":comment-line<ret>"; docstring = "comment line"; }
        { key = "<a-#>"; mode = "normal"; effect = ":comment-block<ret>"; docstring = "comment block"; }
        { key = "m"; mode = "goto"; effect = "<esc>m;"; docstring = "matching char"; }
        { key = "&"; mode = "user"; effect = ":symbol %val{selection}"; docstring = "search symbol"; }
      ];
      hooks = [
        {
          name = "BufNewFile";
          option = "[^*]*";
          commands = "editorconfig-load";
        }
        {
          name = "WinSetOption";
          option = "filetype=python";
          commands = ''
            jedi-enable-autocomplete
            lint-enable
            set-option global lintcmd 'pylint'
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=git-commit";
          commands = "set buffer autowrap_column 72";
        }
        {
          name = "BufSetOption";
          option = "filetype=(c|cpp)";
          once = true;
          commands = ''
            evaluate-commands %sh{
              path="$PWD"
              while [ "$path" != "$HOME" ] && [ "$path" != "/" ]; do
                if [ -e "./tags" ]; then
                  printf "%s\n" "set-option -add current ctagsfiles %{$path/tags}"
                  break
                else
                  cd ..
                  path="$PWD"
                fi
              done
            }
            map global user * '<a-i>w: ctags-search<ret>' -docstring 'search ctags symbol under cursor'
          '';
        }
        {
          name = "ModuleLoaded";
          option = "powerline";
          commands = ''
            require-module powerline_gruvbox
            powerline-theme gruvbox
            powerline-separator global triangle
          '';
        }
        {
          name = "ModuleLoaded";
          option = "kakoune-buffers";
          commands = ''
            map global normal ^ q
            map global normal <a-^> Q
            map global normal q b
            map global normal Q B
            map global normal <a-q> <a-b>
            map global normal <a-Q> <a-B>
            map global normal b ': enter-buffers-mode<ret>' -docstring 'buffers'
            map global normal B ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
          '';
        }
      ];
    };
    extraConfig = ''
      require-module powerline
      powerline-start
      require-module connect
    '';
  };
}
