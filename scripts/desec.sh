#!/usr/bin/env bash
#
ROOT=$(git rev-parse --show-toplevel)
DOMAIN=as.dedyn.io
TOKEN=$(sops decrypt --extract '["desec_token"]' $ROOT/nix/home/as-tui/secrets.yaml)
IP4=31.32.174.211
IP6=2001:861:57c6:4d0f:9e24:72ff:feab:d190

curl https://desec.io/api/v1/domains/$DOMAIN/zonefile/ --header "Authorization: Token $TOKEN"
sleep 1
curl -X PUT https://desec.io/api/v1/domains/$DOMAIN/rrsets/ \
    --header "Authorization: Token $TOKEN" \
    --header "Content-Type: application/json" --data @- <<EOF
    [
      {"subname": "bambi", "type": "A", "ttl": 3600, "records": ["$IP4"]},
      {"subname": "bambi", "type": "AAAA", "ttl": 3600, "records": ["$IP6"]},
      {"subname": "calibre", "type": "A", "ttl": 3600, "records": ["$IP4"]},
      {"subname": "calibre", "type": "AAAA", "ttl": 3600, "records": ["$IP6"]},
      {"subname": "fb", "type": "A", "ttl": 3600, "records": ["$IP4"]},
      {"subname": "fb", "type": "AAAA", "ttl": 3600, "records": ["$IP6"]},
      {"subname": "bianca", "type": "A", "ttl": 3600, "records": ["176.168.154.60"]}
    ]
EOF
sleep 1
curl https://desec.io/api/v1/domains/$DOMAIN/zonefile/ --header "Authorization: Token $TOKEN"

