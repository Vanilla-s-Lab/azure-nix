{ stdenvNoCC, fetchurl, unzip, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "AriaNg";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/mayswind/${pname}/releases"
      + "/download/${version}/${pname}-${version}.zip";
    hash = "sha256-py3F12QOhkwt1SjIjbSTowVgh0ElN+h8bFqYFBpII4A=";
  };

  unpackPhase = "${unzip}/bin/unzip $src";
  installPhase = "mkdir $out && cp -r * $_";
}
