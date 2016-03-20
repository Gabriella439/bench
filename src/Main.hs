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
    { command   :: Text
    , mode      :: Criterion.Mode
    }

parser :: Parser Options
parser =
        Options
    <$> Turtle.argText "command" "The command line to benchmark"
    <*> Criterion.parseWith Criterion.defaultConfig

main :: IO ()
main = do
    o <- Turtle.options "Command-line tool to benchmark other programs" parser
    let io        = Turtle.shells (command o) empty
    let benchmark = Criterion.nfIO (Silently.hSilence [IO.stdout, IO.stderr] io)
    let name      = Text.unpack (command o)
    Criterion.runMode (mode o) [ Criterion.bench name benchmark ]
