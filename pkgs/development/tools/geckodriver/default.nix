{ stdenv, fetchurl, autoPatchelfHook
}:

stdenv.mkDerivation {
    name = "geckodriver-0.26";

      sourceRoot = ".";

    buildInputs = [autoPatchelfHook];

    src = fetchurl {
      url = https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz;
      sha256 = "1h1wp7c9li3qr6wnvysnc38xc78pjl67nw6p1piw27p4v0sa976m";
    };

    buildPhase = '' '';
    installPhase = ''
      mkdir $out
      mkdir -p $out/bin
      cp geckodriver  $out/bin/geckodriver
      '';
}


