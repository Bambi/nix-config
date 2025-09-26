{
  inputs,
  stdenvNoCC,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-cuts";
  version = "1.0.0";

  src = "${inputs.plymouth-themes}/pack_1/cuts";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/cuts
    cp -r * $out/share/plymouth/themes/cuts/
    substituteInPlace $out/share/plymouth/themes/cuts/cuts.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  meta = {
    description = "cuts Plymouth Theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
