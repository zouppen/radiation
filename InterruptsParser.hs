module InterruptsParser (parseInterruptsFromFile, interruptCount) where

import Text.Parsec.ByteString.Lazy
import Text.Parsec.Char
import Text.Parsec.Prim
import Text.Parsec.Combinator
import Records

-- |Reads given interrupt count.
interruptCount :: String -> IO (Maybe Integer)
interruptCount name = do
  list <- parseInterruptsFromFile "/proc/interrupts"
  return $ lookup name $ map namePair list
  where namePair x = (intName x,intCount x)

parseInterruptsFromFile f = do
  result <- parseFromFile parseInterrupts f
  case result of
    Left a -> fail $ show a
    Right a -> return a

parseInterrupts :: Parser [Counter]
parseInterrupts = do
  manyTill anyChar newline -- Skip a line
  manyTill parseInterruptLine eof -- Return lines

parseInterruptLine :: Parser Counter
parseInterruptLine = do
  realspaces
  name <- manyTill anyChar (char ':')
  realspaces
  count <- many digit
  realspaces
  trash <- manyTill anyChar newline
  return $ Counter name (read count) trash

realspaces = many (oneOf " \t")
