class Roman
	@@numbers = {
		"I" => 1, 
		"V" => 5, 
		"X" => 10, 
		"L" => 50, 
		"C" => 100, 
		"D" => 500, 
		"M" => 1000
	}
	

	def self.const_missing(name)
		number, boolean = 0, true
		symbols = name.to_s.chars

		if symbols.length > 3 
			boolean = false if symbols.each_cons(4) { |group| group.count(group[0]) > 3 }
		end
		
		symbols.each_index do |index|
			if index < symbols.length - 1 
				unless 10 * @@numbers[symbols[index]] >= @@numbers[symbols[index + 1]] 	
				boolean = false
				p "Invalid number"
				end
			end
		end 

		if boolean
			symbols.each_index do |index|	
				if @@numbers.key? "#{symbols[index]}"   
					if index < symbols.length - 1 and @@numbers[symbols[index]] < @@numbers[symbols[index + 1]]
						number -= @@numbers[symbols[index]]
					else
							number += @@numbers[symbols[index]]
					end 		
				end
			end
			p number
		end
	end
end


Roman::XV
Roman::LIX
Roman::III
Roman::XCIV
Roman::IC