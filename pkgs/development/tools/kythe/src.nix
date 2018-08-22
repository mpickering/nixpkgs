{ stdenv, binutils , fetchurl, git,  glibc, buildBazelPackage, go}:

buildBazelPackage rec {
  version = "0.0.28";
  name = "kythe-${version}";

  src = fetchurl {
    url = "https://github.com/google/kythe/archive/v0.0.28.tar.gz";
    sha256 = "0vcpn8wdpi3qcg93f6jld02ppasr4j58xknkxs04fwqfvxx63cjy";
  };

  patches = [ ./workspace.patch ];

  buildInputs = [ go git  ];

  bazelTarget = "//...";

  fetchAttrs = {
    sha256 = "1nc98aqrp14q7llypcwaa0kdn9xi7r1p1mnd3vmmn1m299py33ca";
  };

  buildAttrs = {
  };

  meta = with stdenv.lib; {
    description = "kythe";
    longDescription = ''
    The Kythe project was founded to provide and support tools and standards
      that encourage interoperability among programs that manipulate source
      code. At a high level, the main goal of Kythe is to provide a standard,
      language-agnostic interchange mechanism, allowing tools that operate on
      source code — including build systems, compilers, interpreters, static
      analyses, editors, code-review applications, and more — to share
      information with each other smoothly.  '';
    homepage = https://kythe.io/;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
