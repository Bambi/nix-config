_: prev: {
  deploy-rs = prev.deploy-rs.overrideAttrs (old: {
    patches = old.patches or [ ] ++ [ ./patches/deploy-rs-check-no-build.patch ];
  });
}
