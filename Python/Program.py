import random
import time
import os

boardSize = 5

def InitializeBoard():
    return [[random.choice(['s','^','.']) for _ in range(boardSize)] for _ in range(boardSize)]

def NextGen(board):
    PrintBoard(board)
    newBoard = [row[:] for row in board]
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1),(-1, -1), (1, 1), (1, -1), (-1, 1)]
    for y in range(boardSize):
        for x in range(boardSize):
            if board[x][y] == 's':
                newBoard[x][y] = random.choice(['s','.'])
                for i, j in directions:
                    ni, nj = i+x, j+y
                    if 0 <= ni < boardSize and 0 <= nj < boardSize:
                        if board[ni][nj] == '^' and random.random() < .3:
                            newBoard[ni][nj] = 's'
            elif board[x][y] == '.':
                newBoard[x][y] = random.choice(['^','.','.'])
            elif board[x][y] == '^':
                if random.random() < .05:
                    newBoard[x][y] = 's'
    return newBoard

def PrintBoard(board):
    for i in range(boardSize):
        for j in range(boardSize):
            print(board[i][j]+ "  ", end=" ")
        print()

def ManyGens(board, gens):
    for i in range(gens):
        print("gens: " + str(i))
        board = NextGen(board)

board = InitializeBoard()
ManyGens(board, 5)
