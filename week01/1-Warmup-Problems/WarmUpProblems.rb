def fact(n) 
  if n == 0
    1
  else
	 1.upto(n).reduce(&:*)
  end
end

def fac_rec(n)
	if n == 0
		1
	else
		n*fac_rec(n-1)
	end
end

def nth_lucas(n)
  if n < 1
	elsif n == 1
		2
	elsif n == 2
		1
	else
		nth_lucas(n-1) + nth_lucas(n-2)
	end
end

def first_lucas(n)
  list = []
  if n == 1
    list << 2
  elsif n == 2
    list << 2 << 1
  else
  	while n >= 0
  		list << nth_lucas(n)
  		n -= 1
  	end
  	list.reverse.delete_if { |num| num == nil }
  end
end

def count_digits(n)
	n.to_s.length
end

def sum_digits(n)
	sum = 0
	n.to_s.each_char { |char| sum += char.to_i }
	sum
end

def factorial_digits(n)
	sum = 0
	n.to_s.each_char { |char| sum += fact(char.to_i) }
	sum
end

def fib_number(n)
	if n == 1
		1
	elsif n == 2
		11
	else
		first = 1
		second = 1
		result = "11"
		while n > 2 do
			temp = first + second
			first=second
			second=temp
			result += temp.to_s
			n-=1
		end
		result.to_i
	end
end

def hack?(n)
	binary = n.to_s(2)
	binary.count('1').odd? && binary == binary.reverse
end

def next_hack(n)
	n += 1
  n = n.next until hack?(n)
  n
end

def count_vowels(str)
	str.chars.keep_if { |char| char.downcase =~ /[aeiouy]/ }.length
end

def count_consonants(str)
	str.chars.keep_if { |char| char.downcase =~ /[bcdfghjklmnpqrstvwxz]/ }.length
end

def palindrome?(something)
	something.to_s == something.to_s.reverse
end

def p_score(n)
	result = 1
	
	if palindrome?(n)
		result
	else
		while !palindrome?(n)
			result += 1
			n = n + n.to_s.reverse.to_i
		end
		result
	end
end

def prime?(n)
  return false if n < 2

  divider=2
  maxDivider=Math.sqrt(n)
  isPrime=true
  while (isPrime && divider <= maxDivider) do
    if n % divider == 0
      isPrime = false
    end
    divider += 1
  end
  isPrime
end

def first_primes(n)
	result = []
	counter = 0
	first_prime_number = 2
	until n == counter
		if prime?(first_prime_number)
			result << first_prime_number
			counter += 1
		end
		first_prime_number += 1
	end
	result
end

def anagrams?(first, second)
	first.to_s.chars.sort == second.to_s.chars.sort
end

def balanced?(n)
	l = n.to_s.length

	true if l == 1

	arrray_of_digits = n.to_s.chars

	if l.odd?
		center = arrray_of_digits[l / 2]
		parts = n.to_s.partition(center)
		sum_digits(parts[0].to_i) == sum_digits(parts[2].to_i)
	else
		center = arrray_of_digits[(l / 2) - 1]
		parts = n.to_s.partition(center)
		sum_digits(parts[0].to_i) + sum_digits(parts[1].to_i) == sum_digits(parts[2].to_i)
	end
end

def zero_insert(n)
	array = n.to_s.chars

	index = 0
	while index < array.length
		if array[index].to_i + array[index + 1].to_i == 10 or array[index] == array[index + 1]
			array.insert(index + 1, "0")
		end
		index += 1
	end
	array.join.to_i
end

def sum_of_numbers_in_string(str)
	str.to_i if str.to_i.to_s.length == str.length

  sum = 0
  str.split(/[^0-9]+/).each{ |group| sum += group.to_i }
  sum
end