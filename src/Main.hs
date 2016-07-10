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
import qualified Text.Read              as Read
import qualified System.IO              as IO
import qualified System.IO.Silently     as Silently
import qualified Turtle

data Cmd
    = Command Text
    | Commands [Text]
    deriving (Show)

instance Read Cmd where
    readsPrec _ t  =
        -- First attempt to read Commands: ["cmd", "cmd", ...]
        case (Read.readMaybe t :: Maybe [Text]) of
            Just t' -> [(Commands t', "")]
            -- If that fails, fallback to Command
            Nothing -> [(Command $ Text.pack t, "")]

data Options = Options
    { cmd        :: Cmd
    , mode       :: Criterion.Mode
    } deriving (Show)

parser :: Parser Options
parser =
        Options
    <$> Turtle.argRead "command(s)" "The command line(s) to benchmark"
    <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    o <- Turtle.options "Command-line tool to benchmark other programs" parser
    case (cmd o) of
      Command command   -> benchCommand command o
      Commands commands -> benchCommands commands o

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
