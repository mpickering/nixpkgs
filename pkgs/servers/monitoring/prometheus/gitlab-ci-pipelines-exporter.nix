{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.4.9";

  goPackagePath = "github.com/mvisonneau/gitlab-ci-pipelines-exporter";

  goDeps = ./gitlab-ci-pipelines-exporter_deps.nix;

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "13zs8140n4z56i0xkl6jvvmwy80l07dxyb23wxzd5avbdm8knypz";
  };

  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
  };
}
