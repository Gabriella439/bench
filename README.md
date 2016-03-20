# Bench v1.0.0

Think of this as a more powerful alternative to the `time` command.  Use this
command-line tool to benchmark a command using Haskell's @criterion@ library.

Key features:

* Repeated runs
* Detailed statistical output
* Gorgeous HTML output (via the `--output` flag)
  ([Example](http://www.serpentine.com/criterion/fibber.html))
* Also supports CSV or templated output

## Quick Start

First, download the
[Haskell toolchain](https://www.haskell.org/downloads#minimal), which provides
the `stack` build tool.

You will also need to download [git](https://git-scm.com/downloads) if you
haven't done so already.

Then run the following commands from a terminal to build and install the `bench`
tool:

```bash
$ git clone https://github.com/Gabriel439/bench.git
$ cd bench
$ stack install
```

`stack install` will install `bench` to `~/.local/bin` or something similar.
Make sure that the installation directory is on your executable search path
before running the following command.  `stack` will remind you to do this if you
forget.

```bash
$ bench 'sleep 1'  # Don't forget to quote the command line
benchmarking sleep 1
time                 1.003 s    (1.002 s .. 1.003 s)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 1.003 s    (1.003 s .. 1.003 s)
std dev              92.92 μs   (0.0 s .. 101.8 μs)
variance introduced by outliers: 19% (moderately inflated)
```

All output from the command being benchmarked is discarded

## Usage

```
$ bench --help
Command-line tool to benchmark other programs

Usage: bench COMMAND ([-I|--ci CI] [-G|--no-gc] [-L|--time-limit SECS]
             [--resamples COUNT] [--regress RESP:PRED..] [--raw FILE]
             [-o|--output FILE] [--csv FILE] [--junit FILE]
             [-v|--verbosity LEVEL] [-t|--template FILE] [-m|--match MATCH]
             [NAME...] | [-n|--iters ITERS] [-m|--match MATCH] [NAME...] |
             [-l|--list] | [--version])

Available options:
  -h,--help                Show this help text
  COMMAND                  The command line to benchmark
  -I,--ci CI               Confidence interval
  -G,--no-gc               Do not collect garbage between iterations
  -L,--time-limit SECS     Time limit to run a benchmark
  --resamples COUNT        Number of bootstrap resamples to perform
  --regress RESP:PRED..    Regressions to perform
  --raw FILE               File to write raw data to
  -o,--output FILE         File to write report to
  --csv FILE               File to write CSV summary to
  --junit FILE             File to write JUnit summary to
  -v,--verbosity LEVEL     Verbosity level
  -t,--template FILE       Template to use for report
  -m,--match MATCH         How to match benchmark names ("prefix" or "glob")
  -n,--iters ITERS         Run benchmarks, don't analyse
  -m,--match MATCH         How to match benchmark names ("prefix" or "glob")
  -l,--list                List benchmarks
  --version                Show version info
```

## Development Status

[![Build Status](https://travis-ci.org/Gabriel439/bench.png)](https://travis-ci.org/Gabriel439/bench)

This is a pretty simple utility which just wraps `criterion` in a command-line
tool, so I don't expect this project to change much.  However, only time will
tell.

## License (BSD 3-clause)

Copyright Gabriel Gonzalez (c) 2016

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following
  disclaimer in the documentation and/or other materials provided
  with the distribution.

* Neither the name of  nor the names of other
  contributors may be used to endorse or promote products derived
  from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
