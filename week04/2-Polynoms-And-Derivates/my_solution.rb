def sum_same_power_coef(string)
  array = string.delete(" ").split('+')
  powers_and_coef = Hash.new(0)
  array.each do |element|
    if element.include? 'x^'
      coef_infront_of_x, power_of_x = 1, 1
      coef_infront_of_x = element.to_i if element.to_i != 0
      power_of_x = element.reverse.to_i.to_s.reverse.to_i if element.reverse.to_i.to_s.reverse.to_i != 0
      powers_and_coef[power_of_x] = coef_infront_of_x + powers_and_coef[power_of_x]
    elsif element.include? 'x'
      coef_infront_of_x = 1
      coef_infront_of_x = element.to_i if element.to_i != 0
      powers_and_coef[1] = coef_infront_of_x + powers_and_coef[1]
    else
      powers_and_coef[0] = element.to_i + powers_and_coef[0]
    end
  end
  powers_and_coef = powers_and_coef.sort.reverse.to_h

  array = []
  powers_and_coef.each do |key, value|
    string = ''
    if key > 1
      string = value.to_s + 'x^' + key.to_s
    elsif key == 1
      string = value.to_s + 'x'
    else
      string = value.to_s
    end
    array << string 
  end
  puts 'The derivative of f(x) = ' + array_to_good_looking_polynom(array) + ' is:'
  derive(array)
end

def array_to_good_looking_polynom(array)
  string = ''
  array.each do |element|
    string += element + ' + '
  end
  string = string.slice(0..string.length - 4)
  string 
end

def derive(array)
  better_array = []
  array.each do |element|
    map_element = ''
    if element.include? 'x'
      coef_infront_of_x, power_of_x = 1, 1
      coef_infront_of_x = element.to_i if element.to_i != 0
      power_of_x = element.reverse.to_i.to_s.reverse.to_i if element.reverse.to_i.to_s.reverse.to_i != 0

      if power_of_x > 2
        map_element = (power_of_x * coef_infront_of_x).to_s + "x^" + (power_of_x - 1).to_s
      elsif power_of_x == 2
        map_element = (power_of_x * coef_infront_of_x).to_s + "x"
      else
        map_element = (power_of_x * coef_infront_of_x).to_s 
      end
    else
      map_element = ''
    end
    better_array << map_element
  end 
  better_array.delete("")   

  final =''
  better_array.each do |element|
    final += element + " + "
  end

  "f'(x) = " + final.slice(0..final.length - 4)
end

p sum_same_power_coef('x^101')
