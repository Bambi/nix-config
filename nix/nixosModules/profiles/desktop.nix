{ pkgs, ... }: {
  console.useXkbConfig = true; # use xkbOptions in tty.
  services.xserver = {
    enable = false;
    layout = "us";
    xkbVariant = "intl";
  };
  location.provider = "geoclue2";

  environment.systemPackages = with pkgs; [
    nuspell
    hyphen
    hunspell
    hunspellDicts.en_US
    hunspellDicts.fr-any
  ];
}
