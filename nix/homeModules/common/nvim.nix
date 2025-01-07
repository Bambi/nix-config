{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        lsp = {
          enable = true;
        };
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        languages = {
          nix.enable = true;
          clang.enable = true;
          markdown.enable = true;
          python.enable = true;
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;
          enableExtraDiagnostics = true;
        };
        statusline.lualine = {
          enable = true;
          theme = "gruvbox";
        };
        visuals = {
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
          cellular-automaton.enable = true;
        };
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;
        snippets.luasnip.enable = true;
        filetree = {
          neo-tree = {
            enable = true;
          };
        };
        tabline = {
          nvimBufferline.enable = true;
        };
        treesitter.context.enable = true;
        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };
        git = {
          enable = true;
          gitsigns.enable = true;
        };
        notify = {
          nvim-notify.enable = true;
        };
        utility = {
          diffview-nvim.enable = true;
          motion = {
            hop.enable = true;
            leap.enable = true;
          };
        };
        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };
        comments = {
          comment-nvim.enable = true;
        };
        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          fastaction.enable = true;
        };
      };
    };
  };
}
