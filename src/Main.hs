{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}

module Main where

import Control.Applicative
import Data.Monoid ((<>))
import Data.Text (Text)
import Turtle (ExitCode(..), Parser, ShellFailed(..), s, (%))

import qualified Control.Exception
import qualified Criterion
import qualified Criterion.Main         as Criterion
import qualified Criterion.Main.Options as Criterion
import qualified Data.Text              as Text
import qualified Data.Version
import qualified Options.Applicative
import qualified Paths_bench
import qualified System.IO              as IO
import qualified System.IO.Silently     as Silently
import qualified System.Process
import qualified Turtle

version :: Text
version = Text.pack (Data.Version.showVersion Paths_bench.version)

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
    let createProcess =
            (System.Process.shell (Text.unpack command))
                { System.Process.std_in  = System.Process.NoStream
                }

    let io = do
            exitCode <- Turtle.system createProcess empty
            case exitCode of
                ExitFailure _ -> do
                    Control.Exception.throwIO (ShellFailed command exitCode)
                _  -> do
                    return ()

    let benchmark = Criterion.nfIO (Silently.hSilence [IO.stdout, IO.stderr] io)

    Criterion.bench (Text.unpack command) benchmark
