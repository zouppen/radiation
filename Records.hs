module Records where

-- |This counter supports interrupt counter on uniprocessor systems
data Counter = Counter { intName  :: String
                       , intCount :: Integer
                       , trash    :: String
                       } deriving (Show)

-- |This represents a single IRI device.
data Device = Device { powerPin :: String -- ^GPIO of controlling power supply.
                     , pulseInt :: String -- ^Pulse interrupt name.
                     }
