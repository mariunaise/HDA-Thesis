{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShell = pkgs.mkShell rec {
        buildInputs = with pkgs; [
        ];
        nativeBuildInputs = with pkgs; [
          python312Packages.pandas
          python312Packages.matplotlib
          python312Packages.imageio
          python312Packages.requests
          python312Packages.csvw
          python312
        ];
      };

      packages.default = pkgs.mkDerivation {};

      

    }
  );
}
