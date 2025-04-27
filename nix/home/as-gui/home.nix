{ inputs, pkgs, ... }: {
  imports = [
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
