module Main where

import Data.Time.Clock
import System.Posix.Unistd (sleep)
import Iri

-- |Measures radiation for given number of seconds. Returns pulses per
-- million seconds.
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
  (dur,n) <- measure 30
  let c_per_Ms = round $ 1e6 * (fromInteger n) / dur
  putStrLn $ show c_per_Ms
