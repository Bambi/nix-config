{
  lib,
  makeWrapper,
  runCommand,
  # runtime deps
  bash,
  busybox,
  openssh,
}:
let
  src = ../../scripts/generate_user_id;
  binName = "generate_user_id";
  deps = [ bash busybox openssh ];
in
runCommand "${binName}"
  {
    nativeBuildInputs = [ makeWrapper ];
    meta = {
      mainProgram = "${binName}";
    };
  }
  ''
    mkdir -p $out/bin
    install -m +x ${src} $out/bin/${binName}

    wrapProgram $out/bin/${binName} \
      --prefix PATH : ${lib.makeBinPath deps}
  ''
