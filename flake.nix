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
          terraform-docs
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
