#!/usr/bin/env -S just --justfile

default:
	@just --list

init:
	git config core.hooksPath .githooks

check:
	statix check nix || true
	nix flake check --no-build

o-install +HOST=`hostname`:
	nh os switch --hostname {{HOST}} .

h-install CONF:
	nh home switch --configuration {{CONF}} .
	# home-manager switch --flake '.#{{CONF}}'

clochette:
	nix build ./installers#nixosConfigurations.clochette.config.system.build.isoImage -o iso-installer

r-install HOST KEYS *DEST:
	./scripts/remote_install {{HOST}} {{KEYS}} {{DEST}}

flash:
	#!/usr/bin/env bash
	iso="$(ls ./iso-installer/iso | pv)"
	# Display fzf disk selector
	dev="/dev/$(lsblk -d -n --output RM,NAME,FSTYPE,SIZE,LABEL,TYPE,VENDOR,UUID | awk '{ if ($1 == 1) { print } }' | fzf | awk '{print $2}')"
	# Format
	pv -tpreb "./iso-installer/iso/$iso" | sudo dd bs=4M of="$dev" iflag=fullblock conv=notrunc,noerror oflag=sync

deploy HOST *ARGS:
	deploy {{ARGS}} .#{{HOST}}

gc:
	nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d
