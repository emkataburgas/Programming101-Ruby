def prepare_meal(number) 
  string = ""
  divideable = true
  while divideable
    if number != 0 && number % 3 == 0
      if string == ""
        string += "spam"
      else
        string += " spam"
      end
      number = number / 3
    elsif number % 5 == 0
      if string == ""
        string += "eggs"
      else
      string += " and eggs"
        end
      number = number / 5
    else divideable = false
    end
  end
    string
end

def an_bn?(word)
  letters = word.length
  is = true
  
  if letters == 0
  elsif letters % 2 == 0
    index = 0
    while index < letters/2
      if word[index] != "a" || word[letters - index - 1] != "b"
        is = false
      end
      index += 1
    end
  else
    is = false
  end
  is
end 

def valid_credit_card?(number)
  is_valid = true
  string_of_number = number.to_s
  transformed_number = ""
  index = string_of_number.length - 1

  if number.odd?
    while index > -1
      if index.odd?
        temp = string_of_number[index].to_i * 2
        transformed_number += temp.to_s
      else
        transformed_number += string_of_number[index]
      end
      index -= 1
    end

  else
    is_valid = false
  end

  def sumDigits(n)
    divide = true
    sum = 0
    while divide do
      if n/10 > 0
        sum += n%10
      else
        sum += n
        divide = false
      end

      n /= 10
    end
    sum
  end

  if sumDigits(transformed_number.to_i) % 10 == 0
  else is_valid = false
  end
  is_valid

end

def goldbach(n)
  def listOfPrimeNumbers(n)
    def primeNumber(n)
      divider=2
      maxDivider=Math.sqrt(n)
      isPrime=true
      while (isPrime && divider<=maxDivider) do
        if n % divider == 0
          isPrime = false
        end
        divider += 1
      end
      isPrime
    end

    primes = []

    k=2
    while k<=n do
      if primeNumber(k)
        primes.push(k)
      end       
      k += 1
    end
    primes
  end

  if n.even?
    array_of_primes = listOfPrimeNumbers(n)
    array =[]

    index = 0
    while index <= (array_of_primes.length - 1) do
      if array_of_primes[index] + array_of_primes[index] == n
        array << [array_of_primes[index], array_of_primes[index]]
      else
        second = array_of_primes.select { |num| array_of_primes[index] + num == n }
        array << [array_of_primes[index], second.first] if !second.empty?
      end
      index += 1
    end
  end
  if array.flatten.length == 2
   array
  else
    if array.length.odd?
      array.take((array.length / 2) + 1)
    else
      array.take((array.length / 2))
    end
 end
end

def magic_square?(matrix)
    row , col , sum_rows , sum_cols  = 0 , 0 , 0 , 0 
  magic = true

  def find_the_magic_sum(matrix)
    sum = 0
    i = 0
    while i < matrix.length
      j = 0
      while j < matrix.length
        sum += matrix[i][j]

        j += 1
      end
      i += 1
    end
    sum / matrix.length
  end

  sum_to_be = find_the_magic_sum(matrix)

  while row < matrix.length
      col = 0
      sum_rows = 0
    sum_cols = 0
      while col < matrix.length
        
        sum_rows += matrix[row][col]
        sum_cols += matrix[col][row]

        col = col.next
      end
      
      magic = false if sum_rows != sum_to_be || sum_cols != sum_to_be
        
      row = row.next
   end

    sum_main = 0
    sum_second = 0
  row = 0
    col = 0
  while row < matrix.length
      col = 0
      while col < matrix.length
      if row == col
        sum_main += matrix[row][col]
      end
      if row + col == matrix.length - 1
        sum_second += matrix[row][matrix.length - 1 - col]
      end
        col +=1
      end
      row += 1
   end
   magic = false if sum_main != sum_to_be || sum_second != sum_to_be


   magic
end

def reduce_file_path(path)
  i = 0
  length = path.length

  #removes extra slashes
  while i < length
    if path[i] == '/' && path[i + 1] == '/' 
      left = path.slice(0, i)
      right = path.slice(i + 1, path.length)
      path = right.prepend(left)
      i -= 1
    end
    i += 1
  end

  def where_to_slice_to(i, path)
    j = i
    slashes = 0
    go = true 
    while slashes < 2 || j > 0
      slashes = slashes.next if path[j] == '/'
      j -= 1
    end   
    j + 1
  end

  #deals with the . and ..
  i = 0
  while i < path.length
    if path[i] == '.'
      if path[i + 1] == '.'
        left = path.slice(0, where_to_slice_to(i, path))
        right = path.slice(i + 2, path.length)
        if left.nil?
          path = right
        else
          path = right.prepend(left)
        end
        i -= i - where_to_slice_to(i, path)
      else
        left = path.slice(0, i - 1)
        right = path.slice(i + 1, path.length - 1)
        path = right.prepend(left)
        i -= 1
      end
    end
    i += 1
  end

  #removes the last slash (if it's there)
  path = path.slice(0, path.length - 1) if path[path.length - 1] == '/' && path.length != 1
  path
end

def numbers_to_message(sequence)
  reduce_cycle = {
    2 => 3,
    3 => 3,
    4 => 3,
    5 => 3,
    6 => 3,
    7 => 4,
    8 => 3,
    9 => 4
  }

  letters = {
    0 => ' ',
    2 => 'a',
    22 => 'b',
    222 => 'c', 
    3 => 'd',
    33 => 'e',
    333 => 'f',
    4 => 'g',
    44 => 'h',
    444 => 'i',
    5 => 'j',
    55 => 'k',
    555 => 'l',
    6 => 'm',
    66 => 'n',
    666 => 'o',
    7 => 'p',
    77 => 'q',
    777 => 'r',
    7777 => 's',
    8 =>  't',
    88 => 'u',
    888 => 'v',
    9 => 'w' ,
    99 => 'x',
    999 => 'y',
    9999 => 'z'
  }


  to_be_letters = []
  letter = ''

  sequence.each_index do |index|
    if sequence[index] == -1
      letter = ''
    else
      letter += sequence[index].to_s

      if sequence[index] != sequence[index + 1] || sequence[index + 1] == -1
        if sequence[index] != 1 && sequence[index] != 0
          letter = letter.slice(letter.length - reduce_cycle[letter[0].to_i]) if letter.length > reduce_cycle[letter[0].to_i]
        end
        to_be_letters << letter
        letter = ''
      end
    end 
  end

  # moje da mapnem array-a ot intove kam stoinostite v hash-a
  string = ''
  capitilize = false

  to_be_letters.each_index do |index|
    if to_be_letters[index].to_i == 0
      string += ' '
    elsif to_be_letters[index].to_i == 1
      capitilize = true
    elsif
      if capitilize
        string += letters[to_be_letters[index].to_i].to_s.capitalize
        capitilize = false
      else
        string += letters[to_be_letters[index].to_i].to_s
      end
    end     
  end

  string
end

def message_to_numbers(sequence)
  letters_to_numbers = {
    ' ' => '0',
    'a' => '2',
    'b' => '22',
    'c' => '222', 
    'd' => '3',
    'e' => '33',
    'f' => '333',
    'g' => '4',
    'h' => '44',
    'i' => '444',
    'j' => '5',
    'k' => '55',
    'l' => '555',
    'm' => '6',
    'n' => '66',
    'o' => '666',
    'p' => '7',
    'q' => '77',
    'r' => '777',
    's' => '7777',
    't' => '8',
    'u' => '88',
    'v' => '888',
    'w' => '9',
    'x' => '99',
    'y' => '999',
    'z' => '9999',
    'A' => '12',
    'B' => '122',
    'C' => '222', 
    'D' => '13',
    'E' => '133',
    'F' => '1333',
    'G' => '14',
    'H' => '144',
    'I' => '1444',
    'J' => '15',
    'K' => '155',
    'L' => '1555',
    'M' => '16',
    'N' => '166',
    'O' => '1666',
    'P' => '17',
    'Q' => '177',
    'R' => '1777',
    'S' => '17777',
    'T' => '18',
    'U' => '188',
    'V' => '1888',
    'W' => '19',
    'X' => '199',
    'Y' => '1999',
    'Z' => '19999'
  }

  array_to_return = []

  sequence.each_char do |char|
    temp = letters_to_numbers[sequence[char].to_s].chars
    if temp[0] == 1
      if temp[1].to_i == array_to_return[array_to_return.length - 1]
        array_to_return << -1
      end
      
      temp.each do |char|
        array_to_return << char.to_i
      end
    else
      if temp[0].to_i == array_to_return[array_to_return.length - 1]
        array_to_return << -1
      end 

      temp.each do |char|
        array_to_return << char.to_i
      end
    end
  end
  array_to_return
end