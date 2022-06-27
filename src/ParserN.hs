module ParserN where

import           Control.Monad.State (MonadState (get, put), State, evalState)
import           Data.List.Split     (splitOn)
import           Library
import           System.IO           ()


parserN :: [String] -> State (ParserState FFString) [FFString]
parserN (l:list) = do
    (state, fflib) <- get
    case (state,checkString l) of
        (_,"Indexes")          -> put (Ignore, fflib)
        (_,"Atoms")            -> put (Read, writeContainer (purify (splitOn "." l !! 1)) : fflib)
        (Read,"Data String")   -> put (Read, appendAtom (writeFFAtom l) (head fflib): tail fflib)
        (Ignore,"Data String") -> put (Ignore,  fflib)
        (_,"Nothing")          -> put (Ignore,  fflib)
        _                      -> put (Ignore,  fflib)
    parserN list

parserN [] = do
    (_, ffLibArray) <- get
    return ffLibArray

checkString :: String -> String
checkString l
        | head (splitOn " " l) == "!!index" = "Indexes"
        | head (splitOn " " l) == "" = "Data String"
        | (splitOn "." (head (splitOn " " l)) !! 3) == "atoms" = "Atoms"
        | otherwise = "Nothing"

writeFFAtom :: String -> (String,String)
writeFFAtom string = (purify (splitOn " " string !! 1)
                    , purify (splitOn " " string !! 1) ++ "-" ++ purify (splitOn " " string !! 8) )

appendAtom :: (String,String) -> FFString -> FFString
appendAtom (atom,ffatom) (FFString nucl array) = FFString nucl ((atom,ffatom):array)

writeContainer :: String -> FFString
writeContainer string = FFString string []

parseLibrary :: String -> ParserState  FFString -> [FFString]
parseLibrary file = evalState (parserN $ lines file)
