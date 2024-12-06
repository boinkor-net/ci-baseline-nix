{
  description = "a flake that should successfully pass the baseline-nix tests";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    eachSystem = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
      );
  in {
    formatter = eachSystem ({pkgs, ...}: pkgs.alejandra);
    packages = eachSystem ({pkgs, ...}: {default = pkgs.hello;});
  };
}
