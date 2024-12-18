{
  programs.nixvim = {
    enable = true;
    viAlias = true;

    colorschemes.gruvbox.enable = true;
    plugins = {
      lightline.enable = true;
      nvim-autopairs.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
        # trouble = true;
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            options.desc = "Telescope Git Files";
          };
        };
        extensions.fzf-native = { enable = true; };
      };
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings.indent.enable = true;
      };
      treesitter-context = {
        enable = true;
        settings.maxLines = 2;
      };
      rainbow-delimiters.enable = true;
      bufferline.enable = true;
      nvim-tree = {
        enable = true;
        openOnSetupFile = true;
        autoReloadOnWrite = true;
      };
      web-devicons.enable = true;
    };

    opts = {
      number = true;
      shiftwidth = 4;
    };

    globals.mapleader = " ";
    keymaps = [
      # Global
      # Default mode is "" which means normal-visual-op
      {
        key = "<C-n>";
        action = "<CMD>NvimTreeToggle<CR>";
        options.desc = "Toggle NvimTree";
      }
      {
        key = "<leader>c";
        action = "+context";
      }
      {
        key = "<leader>co";
        action = "<CMD>TSContextToggle<CR>";
        options.desc = "Toggle Treesitter context";
      }
      # File
      {
        mode = "n";
        key = "<leader>f";
        action = "+find/file";
      }
      # Git
      {
        mode = "n";
        key = "<leader>g";
        action = "+git";
      }
      # Tabs
      {
        mode = "n";
        key = "<leader>t";
        action = "+tab";
      }
      {
        mode = "n";
        key = "<leader>tn";
        action = "<CMD>tabnew<CR>";
        options.desc = "Create new tab";
      }
      {
        mode = "n";
        key = "<leader>td";
        action = "<CMD>tabclose<CR>";
        options.desc = "Close tab";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<CMD>tabnext<CR>";
        options.desc = "Go to the sub-sequent tab";
      }
      {
        mode = "n";
        key = "<leader>tp";
        action = "<CMD>tabprevious<CR>";
        options.desc = "Go to the previous tab";
      }
      # Terminal
      {
        # Escape terminal mode using ESC
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
        options.desc = "Escape terminal mode";
      }
    ];
  };
}
