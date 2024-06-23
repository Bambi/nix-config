final: prev: {
  nebula = prev.nebula.overrideAttrs (oldAttrs: rec {
    version = "1.8.2";

    src = prev.fetchFromGitHub {
      owner = "slackhq";
      repo = oldAttrs.pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-tbzdbI4QTLQcJ6kyD3c+jQvXn9ERV/9hrzNPXV9XwVM=";
    };

    vendorHash = "sha256-BL9Tx87pBZIAuoneu6Sm2gjyTTC6yOZv5GVYNNeuhtw=";
  });
}
