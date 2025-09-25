{
  inputs,
  stdenvNoCC,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-colorful_loop";
  version = "1.0.0";

  src = "${inputs.plymouth-themes}/pack_1/colorful_loop";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/colorful_loop
    cp -r * $out/share/plymouth/themes/colorful_loop/
    substituteInPlace $out/share/plymouth/themes/colorful_loop/colorful_loop.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  meta = {
    description = "colorful_loop Plymouth Theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
