# Personal NixOS Configuration files
Theses are configuration files I use for some of my machines.
They are very a much a WIP / may be broken.

# Install a New Machine
- build iso installer: `just clochette`
- flash installer: `just flash`
- boot installer on target machine and get hardware-configuration.nix with `nixos-generate-config --show-hardware-config --ni-filesystems`
- generate new host keys in a tmp dir: `ROOTDIR=keys ./scripts/casign -h <host name>`
- update configuration for the new machine (configuration.nix, hardware-configuration.nix, disk-config.nix, secrets, nebula keys and cartifiactes, ...)
- install the new host: `just r-install <host name> <keys dir>`

# Install (obsolete)

Maybe needed on a fresh installed machine:
nix --extra-experimental-features nix-command --extra-experimental-features flakes develop

Install home configuration:
home-manager switch --flake .#as@home

## babar installation

1. From the NixOS installer launch installation:
   `HOME=/mnt/home/as ./bootstrap -i babar -s`

2. Update the secrets for the new machine:
   get hosts age key: `ssh-to-age -i /etc/ssh/ssh_host_ed25519.pub` and
   put the the ket in the `.sops.yaml` file.
   Then update the secrets: `sops updatekeys host/babar/secrets.yaml`

3. Reboot

4. Sign ssh keys with CA:
   `sudo ./scripts/casign -h && ./scripts/casign -u`

# Various Useful Commands For Installation

setup wifi form intaller:
```
sudo iwlist scan |grep ESSID
sudo systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "ESSID"
set_network 0 psk "PASSWD"
enable_network 0
```

setup wifi from an OS:
```
nmcli device wifi connect <ssid> password <password>
```

git operation with a specific identity:
```
GIT_SSH_COMMAND="ssh -i id_ed25519" git clone ...
```

enable flakes:
```
export NIX_CONFIG = "extra-experimental-features = nix-command flakes"
```

# Flatpack
Setup the flathub repo: `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`
Add a package: `flatpak install flathub com.google.Chrome`
Run Chrome under Wayland: `flatpak run com.google.Chrome --enable-features=UseOzonePlatform --ozone-platform=wayland`
