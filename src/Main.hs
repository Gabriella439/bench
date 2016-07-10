{-# LANGUAGE OverloadedStrings  #-}

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
    { commands   :: [Text]
    , mode       :: Criterion.Mode
    } deriving (Show)

parser :: Parser Options
parser =
        Options
    <$> Turtle.argRead "commands" "The command line to benchmark"
    <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    putStrLn "hi"
    o <- Turtle.options "Command-line tool to benchmark other programs" parser
    print o
    let ios       = map (\o' -> Turtle.shells o' empty) (commands o)
    let benchmarks = map (\io -> Criterion.nfIO (Silently.hSilence [IO.stdout, IO.stderr] io)) ios
    let benches    = map (\(command, benchmark) -> Criterion.bench (Text.unpack command) benchmark) $ zip (commands o) benchmarks
    Criterion.runMode (mode o) [Criterion.bgroup "commands" benches]
