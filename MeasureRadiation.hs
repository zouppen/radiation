module Main where

import Data.Time.Clock
import System.Posix.Unistd (sleep)
import Iri

-- |Measures radiation for given number of seconds. Returns duration
-- and pulse count.
measure :: Int -> IO (NominalDiffTime, Integer)
measure len = do
  powerOn
  sleep 2 -- Wait for meter to climb up.
  beforePulses <- getPulseCount
  beforeTime <- getCurrentTime
  sleep len
  afterPulses <- getPulseCount
  afterTime <- getCurrentTime
  powerOff
  return $ (diffUTCTime afterTime beforeTime,afterPulses-beforePulses)

main = do
  ret <- measure 15
  putStrLn $ show ret
