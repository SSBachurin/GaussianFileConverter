module ParserG where
import           Control.Monad.State (MonadState (get, put), State, evalState)
import           Data.List           (isInfixOf)
import           Data.List.Split     (splitOn)
import           Library
import           System.IO           ()

parserG2 :: String -> [FFString] -> String
parserG2 l ffstring
    | checkString l == "Nothing" = l ++ "\n"
    | checkString l == "Data String" = processString l ffstring  ++ "\n"
    | otherwise  = error "Cannot replace"

parseFile2 :: String -> [FFString] -> [String]
parseFile2 file array = map (`parserG2` array) (lines file)

checkString :: String -> String
checkString l
        | null l = "Nothing"
        | "PDBName" `isInfixOf` l = "Data String"
        | otherwise = "Nothing"

findContainer :: String -> [FFString] -> FFString
findContainer _ [] = error "Не могу добавить параметры - Residue Name not found"
findContainer _ [FFString _ []] = error "Не могу добавить параметры - Empty container?"
findContainer nucleotide (ffstring:ffarray)
    | FFString nucleotide [] =<>= ffstring = ffstring
    | FFString nucleotide [] /=<>= ffstring = findContainer nucleotide ffarray
findContainer _ _ = error "Unexpected behaviour"

recoverAtomParm :: FFString -> String -> Maybe String
recoverAtomParm (FFString n ((a,c):array)) atom
            | atom == a =  Just c
            | atom /= a = recoverAtomParm (FFString n array) atom
recoverAtomParm _ _ = Nothing

processString :: String -> [FFString] -> String
processString string fflib = fromMaybe string (recoverAtomParm (findContainer (takeNucl string) fflib) (takeAtom string))

