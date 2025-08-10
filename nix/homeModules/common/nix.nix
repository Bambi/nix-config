{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ nix-search-tv ];
    shellAliases = {
      ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };
  };
}
