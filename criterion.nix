{ mkDerivation, aeson, ansi-wl-pprint, base, base-compat, binary
, bytestring, cassava, code-page, containers, deepseq, directory
, exceptions, fetchgit, filepath, Glob, HUnit, js-flot, js-jquery
, microstache, mtl, mwc-random, optparse-applicative, parsec
, QuickCheck, semigroups, statistics, stdenv, tasty, tasty-hunit
, tasty-quickcheck, text, time, transformers, transformers-compat
, vector, vector-algorithms
}:
mkDerivation {
  pname = "criterion";
  version = "1.2.4.0";
  src = fetchgit {
    url = "https://github.com/bos/criterion";
    sha256 = "0ir02sgfr40y77bh5q1sajld387bjkwl5gdlc7cwz9xcyadk8019";
    rev = "bea91eae7a6c0d4246045f27c9462ea6d138591a";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base base-compat binary bytestring cassava
    code-page containers deepseq directory exceptions filepath Glob
    js-flot js-jquery microstache mtl mwc-random optparse-applicative
    parsec semigroups statistics text time transformers
    transformers-compat vector vector-algorithms
  ];
  executableHaskellDepends = [ base optparse-applicative ];
  testHaskellDepends = [
    aeson base bytestring deepseq directory HUnit QuickCheck statistics
    tasty tasty-hunit tasty-quickcheck vector
  ];
  homepage = "http://www.serpentine.com/criterion";
  description = "Robust, reliable performance measurement and analysis";
  license = stdenv.lib.licenses.bsd3;
}
