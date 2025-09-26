{ lib, rustPlatform, fetchFromGitHub, libseccomp }:
rustPlatform.buildRustPackage rec {
  pname = "hakoniwa";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "souk4711";
    repo = "hakoniwa";
    rev = "v${version}";
    hash = "sha256-MJxMOvWibGrRekN8TpPZ9J7U+Lp5DCCjH2De8VXnqJE=";
  };

  cargoHash = "sha256-W/xcNGXutEyqLvYMJxfZPBlOcaRgGeppxfJ7GFPXaE4=";

  buildInputs = [
    libseccomp
  ];

  # Tests tries to use /bin/sleep
  doCheck = false;

  meta = {
    description = "Process isolation for Linux using namespaces, resource limits, landlock and seccomp";
    homepage = "https://github.com/souk4711/hakoniwa";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [];
    mainProgram = "hakoniwa";
  };
}
