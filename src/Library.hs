module Library where
import           Data.List.Split (splitOn)
data FFString = FFString String [(String,String)] deriving Show

class EqPartial a where
    (=<>=) :: a -> a  -> Bool
    (/=<>=) :: a -> a  -> Bool

instance EqPartial FFString where
    (FFString n1 a1) =<>= (FFString n2 a2) = n1 == n2
    (FFString n1 a1) /=<>= (FFString n2 a2) = n1 /= n2

type ParserState a = (ParserStateValue, [a])
data ParserStateValue = Ignore | Read

purify :: String -> String
purify = filter (/= '"')

takeTail :: String -> String
takeTail string = last (splitOn ")" (splitOn "(" string !! 1))
takeHead :: String -> String
takeHead string = splitOn " " (head $ splitOn "(" string) !! 1 ++ "-"
takeAtom :: String -> String
takeAtom string = head (map (splitOn "=") (splitOn "," string)) !! 1
takeNucl :: String -> String
takeNucl string = (map (splitOn "=") (splitOn "," string) !! 1) !! 1

fromMaybe :: String -> Maybe String -> String
fromMaybe sinput (Just soutput) = takeHead sinput ++ soutput ++ takeTail sinput
fromMaybe sinput Nothing        = sinput

nextElem :: String -> [String] -> String
nextElem elem (x:xs)
    | elem /= x = nextElem elem xs
    | elem == x = head xs
    | otherwise = error "Incorrect element required"
nextElem elem [] = "End of the List"

