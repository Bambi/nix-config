{
  inputs,
  stdenvNoCC,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-circle";
  version = "1.0.0";

  src = "${inputs.plymouth-themes}/pack_1/circle";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/circle
    cp -r * $out/share/plymouth/themes/circle/
    substituteInPlace $out/share/plymouth/themes/circle/circle.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  meta = {
    description = "circle Plymouth Theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
