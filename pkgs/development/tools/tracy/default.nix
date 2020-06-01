{ stdenv, lib, darwin, fetchFromGitHub, tbb, gtk2, glfw, pkgconfig, freetype}:
stdenv.mkDerivation rec {
  name    = "tracy-${version}";
  version = "0.6.3";

  buildInputs =
    [glfw pkgconfig]
    ++ lib.optionals stdenv.isDarwin [darwin.apple_sdk.frameworks.Carbon
                                      darwin.apple_sdk.frameworks.AppKit
                                      freetype ]
    ++ lib.optionals stdenv.isLinux [gtk2 tbb];

  buildPhase = ''
    make -C profiler/build/unix/ CFLAGS="${lib.optionalString stdenv.isLinux "-ltbb"} -faligned-allocation" release
    make -C import-chrome/build/unix/ CFLAGS="${lib.optionalString stdenv.isLinux "-ltbb"} -faligned-allocation" release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./profiler/build/unix/Tracy-release $out/bin/Tracy
    cp ./import-chrome/build/unix/import-chrome-release $out/bin/import-chrome
  '';


  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "0pgq8h5gq141zq1k4cgj6cp74kh4zqbp7h4wh29q4grjb04yy06i";
  };


  meta = with stdenv.lib; {
    description = "A real time, nanosecond resolution, remote telemetry frame profiler for games and other applications.";
    homepage = "https://github.com/wolfpld/tracy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mpickering ];
  };
}

