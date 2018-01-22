# You can build this repository using Nix by running:
#
#     $ nix-build -A bench release.nix
#
# You can also open up this repository inside of a Nix shell by running:
#
#     $ nix-shell -A bench.env release.nix
#
# ... and then Nix will supply the correct Haskell development environment for
# you
let
  config = {
    packageOverrides = pkgs: {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: {
          bench = haskellPackagesNew.callPackage ./default.nix { };

          criterion =
            pkgs.haskell.lib.addBuildDepend (pkgs.haskell.lib.appendConfigureFlag (haskellPackagesNew.callPackage ./criterion.nix { }) "-fembed-data-files") haskellPackagesOld.file-embed;

          statistics = pkgs.haskell.lib.dontCheck (haskellPackagesOld.statistics_0_14_0_2);

          turtle = haskellPackagesNew.callPackage ./turtle.nix { };
        };
      };
    };
  };

  pkgs =
    import <nixpkgs> { inherit config; };

in
  { bench = pkgs.haskellPackages.bench;
  }
