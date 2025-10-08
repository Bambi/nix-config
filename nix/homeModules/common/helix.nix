{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [ pkgs.marksman ];
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        mouse = true;
        true-color = true;
        rulers = [ 80 120 ];
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        auto-save.after-delay.timeout = 1000;
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };
        jump-label-alphabet = "hjklabcdefgimnopqrstuvwxyz";
        soft-wrap.enable = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        indent-guides = {
          render = true;
          character = "╎";
        };
        statusline = {
          left = [ "mode" "diagnostics" ];
          center = [ "file-modification-indicator" "file-name" "read-only-indicator" ];
          right = [ "selections" "file-type" "file-encoding" "position-percentage" "position" ];
        };
      };
      keys.normal = {
        D = [ "extend_to_line_end" "delete_selection" ];
        G = "goto_file_end";
        Z = {
          Z = ":wq";
          Q = ":q!";
        };
        ret = [ "move_line_down" "goto_first_nonwhitespace" ];
        space = {
          E = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
            ":insert-output echo \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
          ];
          space = {
            b = ":sh git blame -L %{cursor_line},%{cursor_line} %{buffer_name}";
          };
        };
      };
      keys.insert = {
        C-space = "completion";
        A-o = "open_below";
        A-O = "open_above";
        A-h = "move_char_left";
        A-l = "move_char_right";
        A-j = "move_line_down";
        A-k = "move_line_up";
      };
    };
  };
  home.packages = with pkgs; [
    (writeShellScriptBin "hxs" ''
      SHELL=${bash}/bin/bash
      hxs() {
        RG_PREFIX="${ripgrep}/bin/rg -i --files-with-matches"
        local files
        files="$(
          FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            ${fzf}/bin/fzf --multi 3 --print0 --sort --preview="[[ ! -z {} ]] && ${ripgrep}/bin/rg --pretty --ignore-case --context 5 {q} {}" \
              --phony -i -q "$1" \
              --bind "change:reload:$RG_PREFIX {q}" \
              --preview-window="70%:wrap" \
              --bind 'ctrl-a:select-all'
        )"
        [[ "$files" ]] && exec ${helix}/bin/hx --vsplit $(echo $files | tr \\0 " ")
      }
      hxs "$@"
    '')
  ];
}
