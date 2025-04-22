{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    # defaultEditor = true;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        mouse = true;
        true-color = true;
        rulers = [ 80 120 ];
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          parents = false;
          git-ignore = false;
        };
        indent-guides = {
          render = true;
          character = "╎";
        };
        statusline = {
          left = [ "mode" "diagnostics" ];
          center = [ "file-name" ];
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
    languages = {
      language = [{
        name = "nix";
        language-servers = [ "nixd" "nil" ];
      }];
      language-server.nixd.command = "nixd";
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
