class GameOfLifeBoard
  attr_accessor :board, :generation, :width, :height
  LIVE = "*"
  DEAD = "."

  def initialize(file_name)
    @generation = 1
    @board = Array.new

    f = File.new(file_name)
    f.each do |line|
      linenum = f.lineno
      if linenum == 1
        parseGenerationNumber(line)
      elsif linenum == 2 
        parseBoardSize(line)
      else 
        if !line.strip.empty?
          arr = Array.new
          line.strip.each_char do |c| 
            arr << c
          end
          @board << arr 
        end
      end
    end
  end

  def to_s
    [ 
      "Generation #{@generation}:",
      "#{@height} #{@width}",
      boardStr
    ].join "\n"
  end

  def nextGeneration!
    @generation += 1
    newboard = Array.new
    
    @board.each_index do |i|
      newrow = Array.new
      @board[i].each_index do |j|
        cell = @board[i][j]
        neighbors = getNeighbors(i,j)
        livingNeighbors = neighbors.select { |cell| cell == LIVE }
        #if live 
        if cell == LIVE
          # underpopulation: if fewer than 2 neighbors
          if livingNeighbors.length < 2 
            newrow <<  DEAD
          # overcrowded: if more than 3 live
          elsif livingNeighbors.length > 3
            newrow << DEAD
          # stable: if two or three ^^^ else other conditions
          else
            newrow << LIVE
          end
        # if dead
        else
          # birth if 3 living neighbors
          if livingNeighbors.length == 3
            newrow << LIVE
          #still dead 
          else
            newrow << DEAD
          end
        end
      end
      newboard << newrow
    end
    @board = newboard
    self
  end

  def getNeighbors(i, j) 

    rows    = [i-1, i, i + 1].select { |r| r >= 0 and r < @height }
    columns = [j-1, j, j + 1].select { |c| c >= 0 and c < @width }
    
    neighbors = Array.new

    for r in rows
      for c in columns
        neighbors << @board[r][c] unless i == r and j == c
      end
    end
    neighbors#.select { |n| !n.nil? }
  end

  private
  def parseGenerationNumber(line)
    gen = line.match /Generation (\d+):/
    @generation = gen.nil? ? 0 : gen[1].to_i
  end

  def parseBoardSize(line)
    size = line.match /(\d+)\s+(\d+)/
    if size.nil?
      @height = 0
      @width = 0 
    else
      @height = size[1].to_i
      @width = size[2].to_i
    end
  end

  def boardStr
    @board.map { |row| row.join } .join "\n"
  end
end

if __FILE__ == $0
  gol = GameOfLifeBoard.new(ARGV[0])
  puts gol.to_s
  puts gol.nextGeneration!.to_s
end
