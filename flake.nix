{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.05;
    flake-utils.url = github:numtide/flake-utils;
    typix = {
      url = github:loqusion/typix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst-packages = {
      url = github:typst/packages;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, typix, typst-packages, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      tx = typix.lib.${system};
      typstPackagesSrc = "${typst-packages}/packages";
      typstPackagesCache = pkgs.stdenv.mkDerivation {
        name = "typst-packages-cache";
        src = typstPackagesSrc;
        dontBuild = true;
        installPhase = ''
          mkdir -p "$out/typst/packages"
          cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
        '';
      };

      typstProject = {
        typstSource = "main.typ";
        fontPaths = [
          "./template/resources/"
        ];
      };
      typstProjectSrc = {
        src = ./.;
        XDG_CACHE_HOME = typstPackagesCache;
      };
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          typst
          python312
          python312Packages.pandas
          python312Packages.glob2
          python312Packages.matplotlib
        ];
      };

      packages.HDA-thesis = tx.buildTypstProject (typstProject // typstProjectSrc);
      packages.default = self.packages.${system}.HDA-thesis;

      apps.watch = flake-utils.lib.mkApp { drv = tx.watchTypstProject typstProject; };
      apps.default = self.apps.${system}.watch;
    }
  );
}
