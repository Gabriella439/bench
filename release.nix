let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOs/nixpkgs/archive/d8e0ade97ad89cd7ea4452e41b4abcaf7e04a8b7.tar.gz";

    sha256 = "1rm6z9cch0kld1742inpsch06n97qik30a3njglvq52l8g9xw2jj";
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
