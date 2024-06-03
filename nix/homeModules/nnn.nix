{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      NNN_OPENER = "~/.config/nnn/plugins/nuke";
      NNN_OPTS = "cE";
      NNN_FIFO = "/tmp/nnn.as.fifo";
      NNN_COLORS = "4321";
    };
  };
  programs.nnn = {
    enable = true;
    plugins = {
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.9";
        sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
      }) + "/plugins";
      mappings = {
        i = "preview-tui";
      };
    };
  };
}
