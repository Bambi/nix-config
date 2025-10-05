# Fedora Atomic Nix Install
1. set hostname: `hostnamectl hostname <hostname>`
4. use [thrix](https://thrix.github.io/nix-toolbox/) toolbx image: `toolbox create --image ghcr.io/thrix/nix-toolbox:42`
   clone nix-config and setup user home. nh does not work, use `home-manager switch -b backup --flake .#asg@atomic` instead.
2. generate user keys: `generate_user_ssh`
3. sign the user key with the ca key: `casign`
5. add public key to github (both signing & auth).
5. Add jetbrains fonts: `rpm-ostree install  	https://repos.fyralabs.com/terra42/jetbrainsmono-nerd-fonts-0:3.4.0-1.fc42.noarch.rpm`
6. enable sshd: `systemctl enable sshd.service && systemctl start sshd.service`
