{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
    typst-nix = {
      url = "github:misterio77/typst-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.typst-packages.follows = "typst-packages";
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    , typst-nix
    , typst-packages
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs; {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              typstyle.enable = true;
            };
          };
        };

        packages = {
          default = typst-nix.lib.${system}.mkTypstDerivation {
            name = "assignment-template-typst";
            src = ./.;
            mainFile = "main.typ";
            typstPackages = {
              preview = "${typst-packages}/packages/preview";
            };
          };
        };

        devShells.default = mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;

          nativeBuildInputs = [
            self.checks.${system}.pre-commit-check.enabledPackages
            typst
            typstyle
            tinymist
          ];
        };
      }
    );
}
