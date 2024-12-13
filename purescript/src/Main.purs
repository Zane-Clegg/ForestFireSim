module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Array as Array
import Data.Array.ST (run, thaw, freeze, modify)
import Effect.Random as Random
import Effect.Random (newSeed, runRNG)
-- import Statistics.Distribution.Uniform (uniform)
import Data.Maybe (fromMaybe)
import Data.Tuple (Tuple(..), fst, snd)

data Cell = Empty | Tree | Fire

derive instance showCell :: Show Cell

type Board = Array (Array Cell)

boardSize :: Int
boardSize = 20

initializeBoard :: Effect Board
initializeBoard = do
  seed <- newSeed
  pure $ runRNG seed (Array.replicateA boardSize (Array.replicateA boardSize generateCell))
  
  where
    generateCell = do
      rand <- uniform 0 2
      pure $ case rand of
        0 -> Empty
        1 -> Tree
        _ -> Fire

nextGeneration :: Board -> Effect Board
nextGeneration board = do
  seed <- newSeed
  pure $ runRNG seed (Array.mapWithIndex updateRow board)
  where
    directions = [ Tuple (-1) 0, Tuple 1 0, Tuple 0 (-1), Tuple 0 1, Tuple (-1) (-1), Tuple 1 1, Tuple 1 (-1), Tuple (-1) 1 ]

    updateRow :: Int -> Array Cell -> RNG (Array Cell)
    updateRow x row = Array.mapWithIndex (updateCell x row) row

    updateCell :: Int -> Array Cell -> Int -> Cell -> RNG Cell
    updateCell x row y cell = case cell of
      Fire -> pure Empty
      Empty -> do
        rand <- uniform 0 2
        pure $ if rand == 0 then Tree else Empty
      Tree -> do
        shouldBurn <- uniform 0 19
        if shouldBurn == 0 then
          pure Fire
        else
          pure $ if any isBurningNeighbor (neighbors x y) then Fire else Tree

    isBurningNeighbor :: Tuple Int Int -> Bool
    isBurningNeighbor (Tuple nx ny) = fromMaybe False $ do
      neighborRow <- board !!? nx
      neighborCell <- neighborRow !!? ny
      pure $ neighborCell == Fire

    neighbors :: Int -> Int -> Array (Tuple Int Int)
    neighbors x y = Array.filter isValidCoordinate $ Array.map (\(Tuple dx dy) -> Tuple (x + dx) (y + dy)) directions

    isValidCoordinate :: Tuple Int Int -> Bool
    isValidCoordinate (Tuple nx ny) = nx >= 0 && ny >= 0 && nx < boardSize && ny < boardSize

printBoard :: Board -> Effect Unit
printBoard board = do
  Array.forEach board \row -> do
    log $ Array.map show row # Array.joinWith " "

runSimulation :: Int -> Effect Unit
runSimulation gens = do
  board <- initializeBoard
  simulate board gens

  where
    simulate :: Board -> Int -> Effect Unit
    simulate _ 0 = pure unit
    simulate board gen = do
      log $ "Generation: " <> show gen
      printBoard board
      nextBoard <- nextGeneration board
      simulate nextBoard (gen - 1)

main :: Effect Unit
main = runSimulation 5
