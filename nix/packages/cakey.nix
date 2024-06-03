{ pkgs }:
pkgs.writeText "cakey" "${builtins.readFile ../../identities/id_ed25519_ca_sk}"
