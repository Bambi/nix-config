{ pkgs, ... }: {
  home.file.".config/gdb/gdbinit".text = ''
    set auto-load safe-path /
  '';
}
