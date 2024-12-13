    Random random = new Random();
    int boardSize = 20;
    int totalCells = boardSize*boardSize;
    char[,] board = new char[boardSize,boardSize];

    void GenerateBoard()
    {
        for (int i = 0; i < boardSize; i++)
        {
            for (int j = 0; j < boardSize; j++)
            {
                int cellState = random.Next(0, 3);
                board[i, j] = cellState switch
                {
                    0 => '.',
                    1 => '^',
                    2 => 's',
                    _ => '.'
                };
            }
        }
    }

    void PrintBoard(char[,] board){
        for (int i = 0; i< boardSize; i++){
            for (int j = 0; j<boardSize; j++){
                Console.Write(board[i,j]+ " ");
            }
            Console.WriteLine();
        }
    }

    void RunBoard(char[,] board, int gens)
    {
    for (int i = 0; i < gens; i++)
    {
        Console.WriteLine($"Gen: {i}");
        PrintBoard(board);
        for (int j = 0; j < boardSize; j++)
        {
            for (int k = 0; k < boardSize; k++)
            {
                switch (board[j, k])
                {
                    case '.':
                        if (random.Next(0, 3) == 0) 
                        {board[j, k] = '^'; }
                        break;
                    case '^':
                        if (random.Next(0,20) == 0)
                        {
                            board[j, k] = 's';
                        }
                        break;
                    case 's':
                        if (random.Next(0, 6) == 0)
                        { board[j, k] = '.'; }
                        else
                        { board[j, k] = '#'; }

                        if (random.Next(0, 1) == 0)
                        {
                            for (int di = -1; di <= 1; di++)
                            {
                                for (int dj = -1; dj <= 1; dj++)
                                {
                                    if (di == 0 && dj == 0) continue;

                                    int ni = i + di;
                                    int nj = j + dj;
                                    if (ni >= 0 && ni < boardSize && nj >= 0 && nj < boardSize)
                                    {
                                        if (board[ni, nj] == '^')
                                        {
                                            board[ni, nj] = 's';
                                            di = 2;
                                            dj = 2;
                                        }
                                    }
                                }
                            }
                        }
                        break;
                    case '#':
                        if (random.Next(0, 6) == 0)
                        { board[j, k] = '.'; }
                        else 
                        { board[j, k] = 's'; }

                        if (random.Next(0, 1) == 0)
                        {
                            for (int di = -1; di <= 1; di++)
                            {
                                for (int dj = -1; dj <= 1; dj++)
                                {
                                    if (di == 0 && dj == 0) continue;

                                    int ni = i + di;
                                    int nj = j + dj;
                                    if (ni >= 0 && ni < boardSize && nj >= 0 && nj < boardSize)
                                    {
                                        if (board[ni, nj] == '^')
                                        {
                                            board[ni, nj] = 's';
                                            di = 2;
                                            dj = 2;
                                        }
                                    }
                                }
                            }
                        }
                        break;
                };
            }
        }
    }
        
    }

    GenerateBoard();
    RunBoard(board, 100);
