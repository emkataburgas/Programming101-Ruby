class Cell
  attr_accessor :y, :x

  def initialize(x, y)
    @x = x
    @y = y 
  end
end

class Board
  attr_reader :the_board, :alive_cell, :dead_cell

  def initialize(*c)
    @alive_cell = {
      0 => false,
      1 => false,
      2 => true,
      3 => true,
      4 => false,
      5 => false,
      6 => false,
      7 => false,
      8 => false
    }

    @dead_cell = {
      0 => false,
      1 => false,
      2 => false,
      3 => true,
      4 => false,
      5 => false,
      6 => false,
      7 => false,
      8 => false
    }
    
    first_cycle = true
    max_x, max_y = 0, 0
    
    c.flatten.each do |cell|
      if first_cycle
        max_x = cell.x
        max_y = cell.y
        first_cycle = false
      else
        max_x = cell.x if max_x < cell.x
        max_y = cell.y if max_y < cell.y        
      end
    end  

    temp = Array.new(max_x + 1) { Array.new(max_y + 1) { false }  }

    c.flatten.each do |cell|
      temp[cell.x][cell.y] = true
    end
    
    @the_board = temp

  end

  def new_generation  
    hash = bigger_board_needed?
    p hash
    add_vertically, add_horizontally = 0, 0
    add_horizontally += 1 if hash["east"]
    add_horizontally += 1 if hash["west"]
    add_vertically += 1 if hash["north"]
    add_vertically += 1 if hash["south"]
    
    temp = Array.new(the_board.size + add_vertically) { Array.new(the_board[0].size + add_horizontally) { false }  }
    vertical_offset, horizontal_offset = 0, 0
    vertical_offset = 1 if hash["north"]
    horizontal_offset = 1 if hash["east"]
    the_board.each_index do |x|
      the_board[x].each_index do |y|
         temp[x + vertical_offset][y + horizontal_offset] = true if the_board[x][y]
        end
    end

    @the_board = temp.clone
    temp.each_index do |i|
      @the_board[i] = temp[i]
    end
    


    temp = Array.new(@the_board.length) { Array.new(@the_board[0].length) { |i|  }  }
    @the_board.each_index do |x|
      @the_board[x].each_index do |y|
        if @the_board[x][y]
          temp[x][y] = alive_cell[neighbours_count(x, y)]

        else
          temp[x][y] = dead_cell[neighbours_count(x, y)]
        end
      end
    end   

    @the_board.each_index do |i|
      p the_board[i]
    end

    temp.each_index do |i|
      p temp[i]
    end
    
    temp.each_index do |x|
      temp[x].each_index do |y|
       if temp[x][y]
          @the_board[x][y] = true 
       else
           @the_board[x][y] = false
        end
      end
    end

    @the_board
  end


  def neighbours_count(x, y)
    neighbours = 0
    i = -1
    while i < 2
      j = -1
      while j < 2
        if (i!=0 or j!=0) and x + i < @the_board.length and x + i > -1 and y + j > -1 and y + j < @the_board[0].length
          neighbours = neighbours +  1 if the_board[x + i][y + j]
        end
        j += 1
      end 
    i += 1  
    end

    neighbours
  end

  def bigger_board_needed?
    make_new_board = false
    counter = 0
    direction_to_enlarge = {
      "north"  => false,
      "south" => false,
      "west" => false,
      "east" => false
    }
    
    the_board[0].each do |element| 
      if element
        counter += 1
      else
        counter = 0
      end 

      if counter == 3
        make_new_board = true
        direction_to_enlarge["north"] = true 
        break 
      end
    end
    
    counter = 0
    the_board[the_board.length - 1].each do |element| 
      if element
        counter += 1
      else
        counter = 0
      end 

      if counter == 3
        make_new_board = true 
        direction_to_enlarge["south"] = true 
        break 
      end
    end

    index = 0
    counter = 0
    max_index = the_board.size
    while index < max_index
      if the_board[index][0]
        counter += 1
      else
        counter = 0
      end 

      if counter == 3
        make_new_board = true 
        direction_to_enlarge["east"] = true 
        break 
      end
      index += 1
    end 

    index = 0
    counter = 0
    while index < max_index
      if the_board[index][the_board[0].size - 1]
        counter += 1
      else
        counter = 0
      end 
      if counter == 3
        make_new_board = true 
        direction_to_enlarge["west"] = true 
        break 
      end
      index += 1
    end
    
    direction_to_enlarge
  end
end


a = Cell.new 0, 0
g = Cell.new 0, 1
b = Cell.new 1, 1 
d = Cell.new 2, 0
e = Cell.new 0, 2
f = Cell.new 2, 2
c = Board.new ([a,b,g,d,f,e])
c.new_generation
c.new_generation
c.new_generation
c.new_generation
c.new_generation
