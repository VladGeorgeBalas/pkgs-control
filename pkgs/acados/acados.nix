{
  pkgs ? import <nixpkgs> {},
  ACADOS_WITH_QPOASES ? false,
  ACADOS_WITH_DAQP ? false,
  ACADOS_WITH_QPDUNES ? false,
  ACADOS_WITH_OSQP ? false,
  ACADOS_WITH_HPMPC ? false,
  ACADOS_WITH_CLARABEL ? false,
  ACADOS_WITH_QORE ? false,
  ACADOS_WITH_OOQP ? false,
  BLASFEO_TARGET ? "X64_AUTOMATIC",
  LA ? " 	HIGH_PERFORMANCE",
  ACADOS_WITH_SYSTEM_BLASFEO ? false,
  HPIPM_TARGET ? "GENERIC",
  ACADOS_WITH_OPENMP ? false,
  ACADOS_NUM_THREADS ? null,
  ACADOS_SILENT ? false,
  ACADOS_DEBUG_SQP_PRINT_QPS_TO_FILE ? false,
  ACADOS_DEVELOPER_DEBUG_CHECKS ? false,
  CMAKE_BUILD_TYPE ? "Release",
  ACADOS_UNIT_TESTS ? false,
  ACADOS_EXAMPLES ? false,
  ACADOS_OCTAVE ? false,
  BUILD_SHARED_LIBS ? true,
}:

let
  teraRendererPkg = pkgs.rustPlatform.buildRustPackage rec {
    pname = "tera_renderer";
    version = "0.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "VladGeorgeBalas";
      repo = "tera_renderer";
      rev = "master";
      hash = "sha256-9pepZJgdRLpCEB07ybRVp97O8frZAAWfR0MNYuY5zr0=";
    };

    cargoHash = "sha256-sodxZdm/xfGWCAQlX7Q4PJdysKu43lTNOyzinBSNnhI=";
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "acados";
  version = "0.5.4";

  src = pkgs.fetchFromGitHub {
    owner = "acados";
    repo = "acados";
    rev = "v${version}";
    sha256 = "sha256-gSGUjCVg5NdblGCuxJGyZcOU+57UrAeN2NqaQHCdgec=";
    # sha256 = "sha256-Mt9Ar/FBuEjb0OpliB09DKzwPSJCHPOO1AGLLQ3g1mc=";
    fetchSubmodules = true;
  };

  buildInputs = with pkgs; [ cmake ninja ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if BUILD_SHARED_LIBS then "ON" else "OFF"}"
  ];

  postInstall = ''
    mkdir -p $out/lib
    cat > $out/lib/link_libs.json << EOF
    {
      "acados": "$out/lib/libacados.so",
      "hpipm": "$out/lib/libhpipm.so",
      "blasfeo": "$out/lib/libblasfeo.so"
    }
    EOF
    mkdir -p $out/bin
    cp ${teraRendererPkg}/bin/t_renderer $out/bin/t_renderer
    chmod +x $out/bin/t_renderer
  '';
}
