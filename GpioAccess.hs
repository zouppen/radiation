module GpioAccess where

writeGpioValue :: String -> String -> IO ()
writeGpioValue pin value = do
  writeFile filename value
  where filename = "/sys/class/gpio/gpio" ++ pin ++ "/value"

readGpioValue :: String -> IO String
readGpioValue pin = do
  readFile filename
  where filename = "/sys/class/gpio/gpio" ++ pin ++ "/value"
