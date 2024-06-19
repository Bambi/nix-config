{ pkgs, config, lib, inputs, ... }:
let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
in
with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # hyprplugins.hyprtrails
    ];
    settings = {
      monitor = ",preferred,auto,1";
      windowrule = [ "fullscreen, ^(wlogout)$" "animation fade,^(wlogout)$" ];
      workspace = "s[true],gapsout:150";
      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg";
        "col.inactive_border" = "rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg";
        layout = "dwindle";
        resize_on_border = true;
      };
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        kb_options = [ "grp:alt_shift_toggle" "caps:super" ];
        follow_mouse = true;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0.2; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "adaptive";
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
      };
      decoration = {
        rounding = 10;
        drop_shadow = false;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
      };
      animations = {
        enabled = true;
        first_launch_animation = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          # "borderangle, 1, 30, liner, loop"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_is_master = true;
      };
      env = [
        # hint electron to use wayland
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland"
        "CLUTTER_BACKEND, wayland"
        # "SDL_VIDEODRIVER, \$\{sdl-videodriver}
        "QT_QPA_PLATFORM, wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "MOZ_ENABLE_WAYLAND, 1"
        # for VM
        # "WLR_NO_HARDWARE_CURSORS,1"
        # "WLR_RENDERER_ALLOW_SOFTWARE,1"
        # For nvidia
        # "WLR_NO_HARDWARE_CURSORS,1"
      ];
      "$modifier" = "SUPER";
      bind = [
        "$modifier,Return,exec,footclient"
        "$modifier SHIFT,Return,exec,rofi -show drun -show-icons"
        "$modifier SHIFT,W,exec,web-search"
        "$modifier,W,exec,firefox"
        "$modifier,E,exec,emopicker9000"
        "$modifier,S,exec,screenshootin"
        "$modifier,G,exec,gimp"
        "$modifier,T,exec,thunar"
        "$modifier,Q,killactive,"
        "$modifier,P,pseudo,"
        "$modifier SHIFT,I,togglesplit,"
        "$modifier,F,fullscreen,"
        "$modifier SHIFT,F,togglefloating,"
        "$modifier SHIFT,C,exit,"
        "$modifier,X, togglegroup"
        "$modifier SHIFT,left,movewindow,l"
        "$modifier SHIFT,right,movewindow,r"
        "$modifier SHIFT,up,movewindow,u"
        "$modifier SHIFT,down,movewindow,d"
        "$modifier SHIFT,h,movewindow,l"
        "$modifier SHIFT,l,movewindow,r"
        "$modifier SHIFT,k,movewindow,u"
        "$modifier SHIFT,j,movewindow,d"
        "$modifier,left,movefocus,l"
        "$modifier,right,movefocus,r"
        "$modifier,up,movefocus,u"
        "$modifier,down,movefocus,d"
        "$modifier,h,movefocus,l"
        "$modifier,l,movefocus,r"
        "$modifier,k,movefocus,u"
        "$modifier,j,movefocus,d"
        "$modifier,1,workspace,1"
        "$modifier,2,workspace,2"
        "$modifier,3,workspace,3"
        "$modifier,4,workspace,4"
        "$modifier,5,workspace,5"
        "$modifier,6,workspace,6"
        "$modifier,7,workspace,7"
        "$modifier,8,workspace,8"
        "$modifier,9,workspace,9"
        "$modifier,0,workspace,10"
        "$modifier SHIFT,SPACE,movetoworkspace,special"
        "$modifier,SPACE,togglespecialworkspace"
        "$modifier SHIFT,1,movetoworkspace,1"
        "$modifier SHIFT,2,movetoworkspace,2"
        "$modifier SHIFT,3,movetoworkspace,3"
        "$modifier SHIFT,4,movetoworkspace,4"
        "$modifier SHIFT,5,movetoworkspace,5"
        "$modifier SHIFT,6,movetoworkspace,6"
        "$modifier SHIFT,7,movetoworkspace,7"
        "$modifier SHIFT,8,movetoworkspace,8"
        "$modifier SHIFT,9,movetoworkspace,9"
        "$modifier SHIFT,0,movetoworkspace,10"
        "$modifier CONTROL,right,workspace,e+1"
        "$modifier CONTROL,left,workspace,e-1"
        "$modifier,mouse_down,workspace, e+1"
        "$modifier,mouse_up,workspace, e-1"
        # "LT,Tab,cyclenext"
        # "LT,Tab,bringactivetotop"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
      ];
      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];
      binde = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
    extraConfig =
      concatStrings [
        ''
          exec-once = $POLKIT_BIN
          #exec-once = dbus-update-activation-environment --systemd --all
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = waybar
          exec-once = dunst
          exec-once = hyprctl setcursor Bibata-Modern-Amber 20
          exec-once = foot --server
          #exec-once = nm-applet --indicator
        ''
      ];
  };
  home.packages = with pkgs; [
    dunst
    wlogout
    # pyprland
  ];
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 100;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
        }
      ];
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
