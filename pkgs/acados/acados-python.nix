{ pkgs ? import <nixpkgs> {} }:

let
  acados = import ./acados.nix { inherit pkgs; };

in
pkgs.python3Packages.buildPythonPackage {
  pname = "acados_template";
  version = "0.5.4";
  src = acados.src;
  sourceRoot = "source/interfaces/acados_template";

  pyproject = true;
  build-system = with pkgs.python3Packages; [
    setuptools
    setuptools-scm
  ];

  checkInputs = with pkgs.python313Packages; [
    casadi
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    casadi
    numpy
    scipy
    matplotlib
    cython
    deprecated
  ];

  dontCheckRuntimeDeps = true;  # casadi da fail la deps, poate il fac eu de mana
  doCheck = false;              # same here
}
