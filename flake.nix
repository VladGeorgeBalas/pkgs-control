{
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      acados = import ./pkgs/acados/acados.nix { inherit pkgs; };
      acados_template = import ./pkgs/acados/acados_template.nix { inherit pkgs; };
    };
  };
}
