{
  stdenv,
  lib,
  fetchFromGitLab,
  crow,
  curl,
  glm,
  mbedtls,
  nlohmann_json,
  opencv,
  pkg-config,
  xorg,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openjowelsofts-huenicorn";
  version = "1.0.11";

  src = fetchFromGitLab {
    owner = "openjowelsofts";
    repo = "huenicorn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OoAc1TtJT9BzoPHzTEtDEsLcaSS/nIf5WJDz7BA+d0k=";
  };

  # Libraries
  buildInputs = [
    crow
    curl
    glm
    mbedtls
    nlohmann_json
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  # Binaries
  nativeBuildInputs = [
    cmake
    opencv
    pkg-config
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "huenicorn" "$out/bin/huenicorn"

    runHook postInstall
  '';

  meta = {
    description = "A Linux Ambilight driver for Philips Hue™ devices";
    homepage = "https://gitlab.com/openjowelsofts/huenicorn";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "huenicorn";
  };

})
