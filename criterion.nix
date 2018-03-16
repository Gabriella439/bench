{ mkDerivation, aeson, ansi-wl-pprint, base, base-compat, binary
, bytestring, cassava, code-page, containers, deepseq, directory
, exceptions, filepath, Glob, HUnit, js-flot, js-jquery
, microstache, mtl, mwc-random, optparse-applicative, parsec
, QuickCheck, semigroups, statistics, stdenv, tasty, tasty-hunit
, tasty-quickcheck, text, time, transformers, transformers-compat
, vector, vector-algorithms
}:
mkDerivation {
  pname = "criterion";
  version = "1.4.0.0";
  sha256 = "cc65c71c519372a28aa7a715da95038bc2be5a1ecbd9c1e26408876f06c61a6a";
  revision = "1";
  editedCabalFile = "056p7d95ynrpsm5jr479r9xk7ksniqkz4bza0zdn9a8vmrx591qh";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base base-compat binary bytestring cassava
    code-page containers deepseq directory exceptions filepath Glob
    js-flot js-jquery microstache mtl mwc-random optparse-applicative
    parsec semigroups statistics text time transformers
    transformers-compat vector vector-algorithms
  ];
  executableHaskellDepends = [
    base base-compat optparse-applicative semigroups
  ];
  testHaskellDepends = [
    aeson base base-compat bytestring deepseq directory HUnit
    QuickCheck statistics tasty tasty-hunit tasty-quickcheck vector
  ];
  homepage = "http://www.serpentine.com/criterion";
  description = "Robust, reliable performance measurement and analysis";
  license = stdenv.lib.licenses.bsd3;
}
