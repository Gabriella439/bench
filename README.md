# Bench v1.0.3

This project provides the `bench` command-line tool, which is a more powerful
alternative to the `time` command.  Use `bench` to benchmark a command using
Haskell's `criterion` library.

Key features:

* Repeated runs
* Detailed statistical output
* Gorgeous HTML output (via the `--output` flag)
  ([Example](http://www.serpentine.com/criterion/fibber.html))
* Also supports CSV or templated output

## Quick Start

You can download a pre-built binary for OS X on the releases page:

* https://github.com/Gabriel439/bench/releases

... or you can install `bench` using Haskell's `stack` tool.  To do that, first
download the [Haskell toolchain](https://www.haskell.org/downloads#minimal),
which provides the `stack` tool, then run:

```bash
$ stack setup
$ stack install bench
```

`stack install` will install `bench` to `~/.local/bin` or something similar.
Make sure that the installation directory is on your executable search path
before running `bench`.  `stack` will remind you to do this if you forget.

Once you've installed `bench` (either by download or installation via `stack`),
you can begin benchmarking programs:

```bash
$ bench 'sleep 1'  # Don't forget to quote the command line
benchmarking sleep 1
time                 1.003 s    (1.002 s .. 1.003 s)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 1.003 s    (1.003 s .. 1.003 s)
std dev              92.92 μs   (0.0 s .. 101.8 μs)
variance introduced by outliers: 19% (moderately inflated)

$ bench true
benchmarking true
time                 410.3 μs   (382.3 μs .. 443.3 μs)
                     0.974 R²   (0.961 R² .. 0.987 R²)
mean                 420.7 μs   (406.8 μs .. 435.7 μs)
std dev              47.69 μs   (40.09 μs .. 57.91 μs)
variance introduced by outliers: 81% (severely inflated)
```

All output from the command being benchmarked is discarded.

Multiple commands are also supported:

```bash
$ bench id ls "sleep 0.1"
benchmarking bench/id
time                 4.798 ms   (4.764 ms .. 4.833 ms)
                     0.999 R²   (0.998 R² .. 1.000 R²)
mean                 4.909 ms   (4.879 ms .. 4.953 ms)
std dev              104.6 μs   (78.91 μs .. 135.7 μs)

benchmarking bench/ls
time                 2.941 ms   (2.889 ms .. 3.006 ms)
                     0.996 R²   (0.992 R² .. 0.998 R²)
mean                 3.051 ms   (3.015 ms .. 3.094 ms)
std dev              129.7 μs   (104.3 μs .. 178.3 μs)
variance introduced by outliers: 25% (moderately inflated)

benchmarking bench/sleep 0.1
time                 109.9 ms   (108.5 ms .. 111.0 ms)
                     1.000 R²   (1.000 R² .. 1.000 R²)
mean                 109.2 ms   (108.5 ms .. 109.7 ms)
std dev              903.0 μs   (676.4 μs .. 1.212 ms)
```

You can also output an HTML file graphing the distribution of
timings by using the `--output` flag:

```bash
$ bench 'ls /usr/bin | wc -l' --output example.html
benchmarking ls /usr/bin | wc -l
time                 6.716 ms   (6.645 ms .. 6.807 ms)
                     0.999 R²   (0.999 R² .. 0.999 R²)
mean                 7.005 ms   (6.897 ms .. 7.251 ms)
std dev              462.0 μs   (199.3 μs .. 809.2 μs)
variance introduced by outliers: 37% (moderately inflated)
```

... and if you open that page in your browser you will
get something that looks like this:

![](http://i.imgur.com/2MCKBc2.png)

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
