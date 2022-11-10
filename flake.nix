{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell = pkgs.mkShell {
        name = "terraform-aws-modules";
        packages = with pkgs; [
          terraform
          terraform-ls
          (terraform-docs.overrideAttrs(prev: {
            patches = (prev.patches or []) ++ [
              (fetchpatch{
                url = "https://patch-diff.githubusercontent.com/raw/terraform-docs/terraform-docs/pull/651.patch";
                sha256 = "sha256-5oxWlc4x9q3Xw/eWZKeY0ZPmiksk0SiW15ivreCf9tI=";
              })
            ];
          }))
          tflint
          jq
          pre-commit
          go
          gnumake
        ];

        shellHook = ''
          [ -e "$(git rev-parse --git-dir)/hooks/pre-commit" ] || ${pkgs.pre-commit}/bin/pre-commit install
        '';
      };
    });
}
