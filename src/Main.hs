{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}

module Main where

import Control.Applicative
import Data.Monoid ((<>))
import Data.Text (Text)
import Turtle (Parser, s, (%))

import qualified Criterion
import qualified Criterion.Main         as Criterion
import qualified Criterion.Main.Options as Criterion
import qualified Data.Text              as Text
import qualified Options.Applicative
import qualified System.IO              as IO
import qualified System.IO.Silently     as Silently
import qualified Turtle

version :: Text
version = "1.0.2"

data Options = Options [Text] Criterion.Mode | Version deriving (Show)

parser :: Parser Options
parser =
            Version
        <$  Options.Applicative.flag'
                ()
                (   Options.Applicative.short 'v'
                <>  Options.Applicative.long "version"
                <>  Options.Applicative.help "Version number"
                )
    <|>     Options
        <$> some
                (Turtle.argText "command(s)" "The command line(s) to benchmark")
        <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    x <- Turtle.options "Command-line tool to benchmark other programs" parser
    case x of
        Options [command] mode -> benchCommand  command mode
        Options  commands mode -> benchCommands commands mode
        Version -> do
            Turtle.printf ("bench version "%s%"\n") version

benchCommands :: [Text] -> Criterion.Mode -> IO ()
benchCommands commands mode = do
    let benches = map buildBench commands
    Criterion.runMode mode [Criterion.bgroup "bench" benches]

benchCommand :: Text -> Criterion.Mode -> IO ()
benchCommand command mode = do
    let bench = buildBench command
    Criterion.runMode mode [ bench ]

buildBench :: Text -> Criterion.Benchmark
buildBench command = do
    let io        = Turtle.shells command empty
    let benchmark = Criterion.nfIO (Silently.hSilence [IO.stdout, IO.stderr] io)
    let bench     = Criterion.bench (Text.unpack command) benchmark
    bench
