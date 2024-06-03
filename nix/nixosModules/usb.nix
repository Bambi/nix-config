{ pkgs, ... }:

{
  # USB Automounting
  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  # Enable USB Guard
  services.usbguard = {
    enable = false;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
    rules = ''
      allow id {046d:c069} # Corded Mouse M500
      allow id {047d:2048} # Kensington Orbit Trackball
      allow id {feed:ac18} # Obins Anne Pro 2 C18 (QMK)
      allow id {001f:0b21} # Anlya.cn AB13X USB Audio
    '';
  };

  # Enable USB-specific packages
  environment.systemPackages = with pkgs; [
    usbutils
  ];
}
