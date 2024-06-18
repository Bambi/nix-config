{ pkgs, config, lib, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };
  # conf files from https://github.com/7KIR7/dots.git
  home.file = {
    ".config/waybar" = {
      source = ./minimal;
      recursive = true;
    };
    ".config/waybar/leave.sh" = {
      text = ''
        choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | ${pkgs.rofi}/bin/rofi -dmenu)
        if [[ $choice == "Lock" ]];then
          ${pkgs.hyprlock}/bin/hyprlock --immediate
        elif [[ $choice == "Logout" ]];then
          hyprctl dispatch exit
        elif [[ $choice == "Suspend" ]];then
          systemctl suspend
        elif [[ $choice == "Reboot" ]];then
          systemctl reboot
        elif [[ $choice == "Shutdown" ]];then
          systemctl poweroff
        fi
      '';
    };
  };
}
