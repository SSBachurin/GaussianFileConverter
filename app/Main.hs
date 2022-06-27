{-# LANGUAGE OverloadedStrings #-}
module Main where
        
import ParserN ( parseLibrary )
import Library ( FFString(..), ParserStateValue(Ignore), nextElem )
import ParserG ( parseFile2 )
import System.Environment (getArgs)
import System.Directory ( listDirectory )
import System.FilePath ( takeExtension )
import Data.List ()
import Data.List.Split (splitOn)

startState :: (ParserStateValue, [FFString])
startState = (Ignore, [FFString "" []])

handlerArgs :: [String] -> IO String
handlerArgs args
    | null args =  do
                putStrLn "Enter FF filename"
                getLine
    | "-ff" `elem` args = pure $ nextElem "-ff" args
    | otherwise = error "Incorrect arguments"

handlerLine :: String -> IO [FilePath]
handlerLine line
        | line == "All" = do
                let dir = listDirectory "./"
                filter (\x -> takeExtension x == ".gjf") `fmap` dir
        | takeExtension line == ".gjf" = return [line]
        | otherwise = error "Incorrect arguments"


gjfFileHandler :: [FFString] -> [FilePath] -> IO ()
gjfFileHandler dict (fileName:fpath) = do
                gau <- readFile fileName
                let newGau2 = parseFile2 gau dict
                writeFile ("processed_"++fileName) (mconcat newGau2)
                gjfFileHandler dict fpath
gjfFileHandler dict [] = putStrLn "All files have been processed"

main :: IO ()
main = do
    args <- getArgs

    let filename = handlerArgs args

    file <- filename >>= readFile
    let dict = parseLibrary file startState

    putStrLn "Enter filename to process (or \"All\" to process all .gjf files"
    lineInteractive <- getLine
    let gaunames = handlerLine lineInteractive
    gaunames >>= gjfFileHandler dict
    putStrLn "Done"