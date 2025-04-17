# Personal NixOS Configuration files
Theses are configuration files I use for some of my machines.
They are very much a WIP / may be broken.

# Install a New Machine
Required using an already setup nix machine:
- build iso installer: `just clochette`
- flash installer: `just flash`
- boot installer on target machine and get hardware-configuration.nix with `nixos-generate-config --show-hardware-config --no-filesystems`
- generate new host keys in a tmp dir: `ROOTDIR=keys ./scripts/casign -h <host name>`
- update configuration for the new machine (configuration.nix, hardware-configuration.nix, disk-config.nix, secrets, nebula keys and certificates, ...)
  update .sops.yaml with a new host entry with the age key generated with ssh-to-age -i ./keys/ssh_host_ed25519.pub
- commit the configuration
- install the new host: `just r-install <host name> <keys dir>`

# Install a New Machine From Scratch
All operations are made on the target machine and does not require an already setup Nixos machine.
First install a simple intermediate Nixos configuration:
- boot the official Nixos iso installer
- get the disk configuration for the nachine: `curl -LO https://github.com/Bambi/nix-config/raw/master/nix/nixos/<machine>/disk-config.nix`
- run disko: `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk-config.nix`
- install a first Nixos configuration:
  - `sudo nixos-generate-config --no-filesystems --root /mnt`
  - `sudo cp disk-config.nix /mnt/etc/nixos`
  - adjust `configuration.nix` to add disko (see disko quickstart doc)
    you can also adjust the configuration to:
    - enable ssh (this will generate ssh host keys)
    - add vi
  - `sudo nixos-install`
  - reboot

Then install the final configuration:
- clone the nix-config repo
- add to the host configuration the host public key (`/etc/ssh/ssh_host_ed25519.pub`) 
- update host age key in `.sops.yaml`
- edit or update the host `secrets.yaml` file (`sops updatekeys secrets.yaml`)
- install the host final configuration: `just o-install <hostname>`
- commit changes in the git repo
- reboot, login as `as` then install user home-manager configuration

## WSL Install
Follow instructions on [NIXOS-WSL](https://github.com/nix-community/nixos-wsl).

See instruction [here](https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/8)
to rename the default user.

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
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
```

# Post-install
Steps that require user actions after a fresh install.

## Flatpack
Setup the flathub repo: `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`

Add a package: `flatpak install flathub com.google.Chrome`

Run Chrome under Wayland: `flatpak run com.google.Chrome --enable-features=UseOzonePlatform --ozone-platform=wayland`
