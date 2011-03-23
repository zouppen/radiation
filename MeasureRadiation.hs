module Main where

import System.Posix.Unistd (sleep)
import Iri
import Records --(Device,powerPin,pulseInt)

-- NB. I hate time handling in Haskell. It's quite sophisticated but
-- totally useless in real world. Q: How many Haskell modules do you
-- need to get a UNIX timestamp? A: Three and you still get it as
-- String and you need to provide your own light bulb, too.
import Data.Time.Format (formatTime)
import System.Locale (defaultTimeLocale)
import Data.Time.Clock

data Measurement = Measurement { timestamp :: UTCTime
                               , duration  :: NominalDiffTime
                               , pulses    :: Integer
                               , ucps      :: Integer
                               }

-- |Measures radiation for given number of seconds.
measure :: Device -> Int -> IO Measurement
measure dev len = do
  powerOn dev
  sleep 2 -- Wait for meter to climb up.
  beforePulses <- getPulseCount dev
  beforeTime <- getCurrentTime
  sleep len
  afterPulses <- getPulseCount dev
  afterTime <- getCurrentTime
  powerOff dev
  
  let duration = diffUTCTime afterTime beforeTime
  let pulses = afterPulses-beforePulses
  
  return $ Measurement beforeTime duration pulses (toUcps pulses duration)

-- |Converts pulse count and duration to micropulses per second (µc/s)
toUcps pulses dur = round $ 1e6 * (fromInteger $ pulses) / dur

toUnixTimeString :: UTCTime -> String
toUnixTimeString x = formatTime defaultTimeLocale "%s" x

-- ^Main function which returns pulses per million seconds (µc/s)
main = do
  res <- measure dev 30
  putStrLn $ (toUnixTimeString $ timestamp res)++","++(show $ ucps res)
  
  where dev = Device {powerPin = "5", pulseInt = "34" }
