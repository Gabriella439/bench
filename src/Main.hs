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

data Options
    = Options (Maybe Text) (Maybe Text) [Text] Criterion.Mode
    | Version deriving (Show)

before :: Parser Text
before =
    Options.Applicative.strOption
        (   Options.Applicative.long "before"
        <>  Options.Applicative.help "Specify a command to run before each run of the benchmark"
        <>  Options.Applicative.metavar "command"
        )

after :: Parser Text
after =
    Options.Applicative.strOption
        (   Options.Applicative.long "after"
        <>  Options.Applicative.help "Specify a command to run before after run of the benchmark"
        <>  Options.Applicative.metavar "command"
        )

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
        <$> optional before
        <*> optional after
        <*> some
                (Turtle.argText "command(s)" "The command line(s) to benchmark")
        <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    x <- Turtle.options "Command-line tool to benchmark other programs" parser
    case x of
        Options maybeBefore maybeAfter commands mode -> do
            let benches = map (buildBench maybeBefore maybeAfter) commands

            let benches' = case commands of
                    [_] -> benches
                    _   -> [ Criterion.bgroup "bench" benches ]

            Criterion.runMode mode benches'
        Version -> do
            Turtle.printf ("bench version "%s%"\n") version

buildBench :: Maybe Text -> Maybe Text -> Text -> Criterion.Benchmark
buildBench maybeBefore maybeAfter command = do
    let io cmd = Silently.hSilence [IO.stdout, IO.stderr] $ do
            let createProcess =
                    (System.Process.shell (Text.unpack cmd))
                        { System.Process.std_in  = System.Process.NoStream
                        }

            exitCode <- Turtle.system createProcess empty
            case exitCode of
                ExitFailure _ -> do
                    Control.Exception.throwIO (ShellFailed cmd exitCode)
                _  -> do
                    return ()

    let benchmarkable = Criterion.nfIO (io command)

    let benchmark = Criterion.bench (Text.unpack command) benchmarkable

    let benchmark' = case (maybeBefore, maybeAfter) of
            (Just before_, Just after_) ->
                Criterion.envWithCleanup
                    (io before_)
                    (\_ -> io after_)
                    (\_ -> benchmark)
            (Just before_, Nothing) ->
                Criterion.envWithCleanup
                    (io before_)
                    (\_ -> return ())
                    (\_ -> benchmark)
            (Nothing, Just after_) ->
                Criterion.envWithCleanup
                    (return ())
                    (\_ -> io after_)
                    (\_ -> benchmark)
            (Nothing, Nothing) ->
                benchmark

    benchmark'
