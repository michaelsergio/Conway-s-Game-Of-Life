require_relative 'gameoflife'
require 'gosu'

class GameWindow < Gosu::Window
  
  def initialize
    
    file = ARGV[0].nil? ? "default.gol" : ARGV[0] 
    @gol = GameOfLifeBoard.new(file)
    @size = 600
    @block_size = @size / [@gol.width, @gol.height].max

    @run = false
    @runtimer = 0
    @rundelay = 100

    super(@block_size*@gol.width, @block_size*@gol.height, false)
    self.caption = "Conway's Game of Life"
  end

  def update
    @runtimer += 1
    if @run and @runtimer > @rundelay 
      @gol.nextGeneration!
      @runtimer = 0
    end
  end

  def needs_cursor?
    true
  end

  def draw
    c = Gosu::Color::BLUE
    @gol.board.each_index do |i|
      @gol.board[i].each_index do |j|
        if @gol.board[i][j] == GameOfLifeBoard::LIVE
          draw_quad(j*@block_size, i*@block_size, c,
                    (j+1)*@block_size, i * @block_size, c,
                    (j+1)*@block_size, (i+1)*@block_size,c,
                    j*@block_size, (i+1)*@block_size, c)
        end
      end
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape or id == Gosu::KbQ
      close
    elsif id == Gosu::KbSpace
      @gol.nextGeneration!
    elsif id == Gosu::KbS
      save
    elsif id == Gosu::KbR 
      @run = !@run
      @runtimer = 0
                      
      puts (@run ? "\033[92mIs" : "\033[91mNot") + " Running\033[0m"
    elsif id == Gosu::MsLeft
      twiddleCursor
    elsif id == Gosu::KbRight
      @rundelay -= 5
      puts @rundelay
    elsif id == Gosu::KbLeft
      @rundelay += 5
      puts @rundelay
    end
  end

  def twiddleCursor
    ix = mouse_x / @block_size
    iy = mouse_y / @block_size
    unless @gol.board[iy].nil? or @gol.board[iy][ix].nil?
      status = @gol.board[iy][ix]
      @gol.board[iy][ix] = status == GameOfLifeBoard::LIVE ? GameOfLifeBoard::DEAD : GameOfLifeBoard::LIVE
    end
  end

  def save
    name = "#{@gol.width}x#{@gol.height}-#{Time.now.to_i}.gol"
    contents = @gol.to_s
    File.open(name, 'w') {|f| f.write(contents) }
  end
end

window = GameWindow.new
window.show
