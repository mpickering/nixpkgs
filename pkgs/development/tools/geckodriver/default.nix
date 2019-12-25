{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, darwin
, fetchurl
, unzip
, symlinkJoin
}:

with rustPlatform;

let cargoLock = fetchurl {
      url = "https://hg.mozilla.org/mozilla-central/archive/${vhash}.zip/Cargo.lock";
    sha256 = "0m5m5cnakcm8qil9745gckb83md3mr1kq75y5b4df17y12gqfqjm";
    };
    vhash = "e9783a644016aa9b317887076618425586730d73";
in
buildRustPackage rec {
  version = "0.26.0";
  pname = "geckodriver";
  sourceRoot = "geckodriver.zip/testing/geckodriver";

  src = (fetchurl ({
    url = "https://hg.mozilla.org/mozilla-central/archive/${vhash}.zip/testing";
    sha256 = "1yl9gfcvyd09mgdf3z9zmm7sc33nywmsyyss9rmsvwsid6knng4x";
    name = "geckodriver.zip";
    recursiveHash = true;

    downloadToTemp = true;
    postFetch =
    ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/geckodriver.zip"
      lock="$TMPDIR/cargo.zip"
      mv "$downloadedFile" "$renamed"
      cp "${cargoLock}" "$lock"
      unpackFile "$renamed"
      unzip "$lock"

      mkdir $out
      cp $unpackDir/mozilla-central-${vhash}/Cargo.lock $unpackDir/mozilla-central-${vhash}/testing/geckodriver/Cargo.lock
      mv $unpackDir/mozilla-central-${vhash}/* $out
    '';
  })).overrideAttrs (x: {
  # Hackety-hack: we actually need unzip hooks, too
  nativeBuildInputs = x.nativeBuildInputs ++ [ unzip ];
});



  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "0kbadckn95c02kaq29z8wbqi50hra2c7fgl5cm3yk93ga912l3r8";

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
