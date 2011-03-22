module Records where

-- This counter supports uniprocessor systems
data Counter = Counter { intName  :: String
                       , intCount :: Integer
                       , trash    :: String
                       } deriving (Show)
