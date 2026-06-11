{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      art
      ansel
      darktable
      rapidraw
      gimp
      hugin
      exiv2
      rapid-photo-downloader
    ];
  };
  xdg = {
    configFile =
    let
      genConf = fic: pkgs.replaceVars fic {
        HUGIN = "${pkgs.ART-UC-hugin}/bin/ART-UC-hugin";
      };
    in
    {
      "ART/ctlscripts".source = pkgs.fetchzip {
        url = "https://github.com/artraweditor/ART-ctlscripts/archive/3952d012f94eda3f238c2aca0352463905c1c0f2.zip";
        sha256 = "sha256-+mrJv9+N8VlRDC8ptxW38KXPRF6NvZwzBwvgOBcAP0U=";
      };
      "ART/HaldCLUTs".source = pkgs.fetchzip {
        url = "http://rawtherapee.com/shared/HaldCLUT.zip";
        sha256 = "sha256-OtsHpOKrZImvWnKCTqewyo2xjYg7dwpqxdXLVutfhzw=";
      };
      "ART/usercommands/hugin.txt".source = genConf ./usercommands/hugin;
    };
    dataFile = {
      "lensfun/_mounts.xml".text = ''
        <lensdatabase>
          <mount>
            <name>Micro 4/3 System</name>
            <compat>Minolta AF</compat>
          </mount>
        </lensdatabase>
      '';
    };
  };
}
