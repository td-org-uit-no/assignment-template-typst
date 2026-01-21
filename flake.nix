{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    press = {
      url = "github:RossSmyth/press";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.pre-commit-hooks.flakeModule ];
      perSystem =
        {
          system,
          config,
          pkgs,
          ...
        }:
        let
          fontPackages = with pkgs; [
            stix-two
            noto-fonts
            open-sans
            jetbrains-mono
          ];
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ (import inputs.press) ];
          };

          pre-commit = {
            check.enable = true;
            settings = {
              package = pkgs.prek;
              hooks = {
                nixfmt = {
                  enable = true;
                };
                typstyle = {
                  enable = true;
                };
              };
            };
          };

          packages.default = pkgs.buildTypstDocument rec {
            name = "assignment-template-typst";
            src = ./.;
            file = "main.typ";
            # NOTE: How to add typst packages
            # typstEnv = (
            #   p: [
            #     p.codly_1_3_0
            #     p.ctheorems_1_1_3
            #     p.physica_0_9_7
            #     p.subpar_0_2_2
            #     p.glossarium_0_5_9
            #   ]
            # );
            fonts = fontPackages;
            format = "pdf";

            buildPhase = ''
              runHook preBuild
              mkdir -p $out
              typst c ${file} --root ./ -f ${format} $out/main.pdf
              runHook postBuild
            '';
          };

          devShells.default = pkgs.mkShell {
            name = "thesis";
            packages = with pkgs; [
              # Typst
              typst
              typstyle
              tinymist

              # Utils
              typos
              sd
            ];

            TYPST_FONT_PATHS = pkgs.symlinkJoin {
              name = "typst-fonts";
              paths = fontPackages;
            };

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };
        };
    };
}
