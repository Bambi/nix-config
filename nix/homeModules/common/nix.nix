{ pkgs, ... }: {
  home = {
    # packages = with pkgs; [ nix-search-tv ];
    # shellAliases = {
    #   ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    # };
    packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
    ];
  };
}
