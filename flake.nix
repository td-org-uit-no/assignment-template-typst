{
  description = "Typst Assignment Template";

  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  };

  outputs = { self, flake-schemas, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      schemas = flake-schemas.schemas;

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # Nix formatter
            nixpkgs-fmt
            # Typo checker
            typos
            # Typst CLI, LSP and Formatter
            typst
            typst-lsp
            typstfmt
          ];
        };
      });
    };
}
