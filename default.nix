{ mkDerivation, base, criterion, optparse-applicative, process
, silently, stdenv, text, turtle
}:
mkDerivation {
  pname = "bench";
  version = "1.0.9";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base criterion optparse-applicative process silently text turtle
  ];
  homepage = "http://github.com/Gabriel439/bench";
  description = "Command-line benchmark tool";
  license = stdenv.lib.licenses.bsd3;
}
