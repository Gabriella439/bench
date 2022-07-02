let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOs/nixpkgs/archive/18038cee44aa0c3c99a2319c3c1c4d16d6612d81.tar.gz";

    sha256 = "0b1c2sj6k72nwwny1ibayl2hfgwk3kdwksiijpjl4w48s8s4p5di";
  };

  readDirectory = import ./nix/readDirectory.nix;

  config = {
    packageOverrides = pkgs: {
      haskellPackages = pkgs.haskellPackages.override {
        overrides =
          let
            directoryOverrides = readDirectory ./nix;

            manualOverrides =
              haskellPackagesNew: haskellPackagesOld: {
                criterion =
                  pkgs.haskell.lib.dontCheck
                    (pkgs.haskell.lib.addBuildDepend
                      (pkgs.haskell.lib.appendConfigureFlag
                        (pkgs.haskell.lib.appendConfigureFlag
                          haskellPackagesOld.criterion
                          "-ffast"
                        )
                        "-fembed-data-files"
                      )
                      haskellPackagesOld.file-embed
                    );

                turtle = pkgs.haskell.lib.doJailbreak haskellPackagesOld.turtle;
              };

          in
            pkgs.lib.composeExtensions directoryOverrides manualOverrides;
      };
    };
  };

  pkgs =
    import nixpkgs { inherit config; };

in
  { bench = pkgs.haskellPackages.bench;
  }
