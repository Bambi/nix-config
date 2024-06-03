{ pkgs, cakey }:
pkgs.writeScriptBin "casign" ''
  #!${pkgs.stdenv.shell}
  PATH=$PATH:${pkgs.coreutils-full}/bin

  [ $1 = -h ] && \
  ${pkgs.openssh}/bin/ssh-keygen -s ${cakey} \
       -I "$(hostname) host key" \
       -V -1m:+3650d \
       -h \
       /etc/ssh/ssh_host_*.pub && \
    echo /etc/ssh/*-cert.pub |tr ' ' '\n' |xargs -L 1 ${pkgs.openssh}/bin/ssh-keygen -L -f

  [ $1 = -u ] && (
    ${pkgs.openssh}/bin/ssh-keygen -f ~/.ssh/id_ed25519 -t ed25519
    ssh-keygen -s ${cakey} \
        -I "$(whoami)@$(hostname) user key" \
        -n "$(whoami)" \
        -V -1m:+3650d \
        ~/.ssh/id_ed25519.pub && \
    ${pkgs.openssh}/bin/ssh-keygen -L -f id_ed25519-cert.pub
  )
''
