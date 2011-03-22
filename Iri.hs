module Iri where

import GpioAccess
import InterruptsParser (interruptCount)

powerOn :: IO ()
powerOn = writeGpioValue "5" "1"

powerOff :: IO ()
powerOff = writeGpioValue "5" "0"

getPulseCount :: IO Integer
getPulseCount = do
  maybeCount <- interruptCount "34"
  case maybeCount of
    Just a -> return a
    Nothing -> fail "Interrupt 34 is not registered"

