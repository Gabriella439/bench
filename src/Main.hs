{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}

module Main where

import Control.Applicative
import Data.Text (Text)
import Turtle (Parser)

import qualified Criterion
import qualified Criterion.Main         as Criterion
import qualified Criterion.Main.Options as Criterion
import qualified Data.Text              as Text
import qualified System.IO              as IO
import qualified System.IO.Silently     as Silently
import qualified Turtle

data Options = Options
    { cmd        :: [Text]
    , mode       :: Criterion.Mode
    } deriving (Show)

parser :: Parser Options
parser =
        Options
    <$> some (Turtle.argText "command(s)" "The command line(s) to benchmark")
    <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    o <- Turtle.options "Command-line tool to benchmark other programs" parser
    case (cmd o) of
      [command] -> benchCommand command o
      commands  -> benchCommands commands o

benchCommands :: [Text] -> Options -> IO ()
benchCommands commands opts@Options{..} = do
    let benches = map (\command -> buildBench command opts) commands
    Criterion.runMode mode [Criterion.bgroup "bench" benches]

benchCommand :: Text -> Options -> IO ()
benchCommand command opts@Options{..} = do
    let bench = buildBench command opts
    Criterion.runMode mode [ bench ]

buildBench :: Text -> Options -> Criterion.Benchmark
buildBench command Options{..} = do
    let io        = Turtle.shells command empty
    let benchmark = Criterion.nfIO (Silently.hSilence [IO.stdout, IO.stderr] io)
    let bench     = Criterion.bench (Text.unpack command) benchmark
    bench
