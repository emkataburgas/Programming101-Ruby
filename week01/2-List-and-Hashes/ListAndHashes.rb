def number_to_digits(n)
  Array.new.tap do |result|
    n.to_s.each_char { |char| result << char.to_i }
  end
end

def digits_to_number(n)
  number = ""
  n.each { |num| number += num.to_s }
  number.to_i
end

def max_scalar_product(v1, v2)
  v1 = v1.sort
  v2 = v2.sort

  result, index = 0, 0

  while index < v1.length
    result += v1[index] * v2[index]
    index += 1
  end

  result
end

def max_span(numbers)
  span, i, j = 0, 0, 1

  while i < numbers.length
    current_element = numbers[i]
    j = numbers.length

    while j > i
      if current_element == numbers[j]
        if span < j - i + 1
          span = j - i + 1 
        end
      end
      j -= 1
    end
    i = i.next
  end

  span
end

def sum_matrix(m)
  list_index, index, sum = 0, 0, 0
  
  while list_index < m.length
    index = 0
    while index < m[list_index].length
      sum += m[list_index][index]
      index = index.next
    end
    list_index = list_index.next
  end
  sum
end

def matrix_bombing_plan(matrix)
  hash = {}
  original_matrix = matrix.clone
  original_matrix[0] = matrix[0].clone
  original_matrix[1] = matrix[1].clone
  original_matrix[2] = matrix[2].clone

  sums_of_matrixes = []
  i, j = 0, 0

  while i < matrix.length
    j = 0
    while j < matrix[i].length
      m, n = -1, -1
      matrix = original_matrix.clone
      matrix[0] = original_matrix[0].clone
      matrix[1] = original_matrix[1].clone
      matrix[2] = original_matrix[2].clone
      
      while m < 2
        n = -1
        while n < 2
          if i + m > -1 && i + m < matrix.length && j + n > -1 && j + n < matrix[i].length && (m != 0 || n!= 0)
            matrix[i+m][j+n] = matrix[i+m][j+n] - matrix[i][j]
            matrix[i+m][j+n] = 0 if matrix[i+m][j+n] < 0
          end
          n += 1
        end
        m += 1
      end
      sums_of_matrixes.push(sum_matrix(matrix))
      sums_of_matrixes.each { |sum| hash[[i,j]] = sum }
      j += 1
    end
    i += 1
  end
  hash
end

def group(list)
  final_list, list_of_equals = [], []
  length, i = list.length, 0

  while i < length
    list_of_equals = [] 
    list_of_equals.push(list[i])

    j = i + 1
    same = true
    while same && j < length
      if list[i] == list[j]
        list_of_equals.push(list[j]) 
        i = i.next
      else
        same = false
      end
      j = j.next
    end
    final_list.push(list_of_equals) if list_of_equals.length > 0
    i = i.next
  end

  final_list
end

def max_consecutive(items)
  i, length = 0, 0
  lengths = []

  while i < items.length
    j = i + 1
    length = 0
    consecutive = true
    while j < items.length && consecutive
      if items[i] == items[j]
        length += 1
        if j == items.length - 1
          consecutive = false
          length += 1
          lengths.push(length)  
        end
      else
        consecutive = false
        length += 1
        lengths.push(length)
        i = j - 1
      end
      j += 1
    end
    i += 1
  end

  lengths = lengths.sort.reverse
  lengths[0]
end

def grayscale_histogram(matrix)
  i = 0
  counter = []
  while i < 256
    counter << matrix.flatten.count(i)
    i += 1
  end
  counter
end