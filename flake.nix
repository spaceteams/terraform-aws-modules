{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          name = "terraform-aws-modules";
          packages = with pkgs; [ terraform jq tflint terraform-ls go gnumake ];
        };
      });
}
