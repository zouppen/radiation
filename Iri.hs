module Iri where

import GpioAccess
import InterruptsParser (interruptCount)
import Records (Device, powerPin, pulseInt)

powerOn :: Device -> IO ()
powerOn x = writeGpioValue (powerPin x) "1"

powerOff :: Device -> IO ()
powerOff x = writeGpioValue (powerPin x) "0"

getPulseCount :: Device -> IO Integer
getPulseCount x = do
  maybeCount <- interruptCount (pulseInt x)
  case maybeCount of
    Just a -> return a
    Nothing -> fail $ "Interrupt " ++ (pulseInt x) ++ " is not registered"
