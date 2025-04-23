{ inputs, pkgs, ... }: {
  system = "x86_64-linux";
  modules = [
    ../as-minimal/home.nix
    inputs.self.homeModules.tui
    inputs.self.homeModules.desktop
    { home.stateVersion = "23.11"; }
    inputs.self.homeModules.firefox
    {
      _module.args = {
        FFextensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          privacy-badger
          clearurls
          bitwarden
          tabliss
          darkreader
          vimium
          french-dictionary
          single-file
        ];
      };
    }
  ];
}
