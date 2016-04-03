class Object
	def blank?
		return true if self == nil or self == false
		
		if respond_to? :empty?
			return true if empty? == true
		end

		if self.class == String
			if self.strip.size == 0
				return true
			end
		elsif self.class == Array
			not_blank_elements = self.reject do |element|
				element.blank?
			end

			return true if not_blank_elements.size == 0 
		elsif self.class == Hash
			return true if keys.size ==	0		
		end

		false
	end

	def present?
		!blank?
	end

	def presence
		if present?
			self
		else
			nil
		end
	end

	def try(symbol = nil, &block)
		if self == nil
			nil
		elsif symbol
			self.public_send(symbol)
		elsif block
			yield self
		end
	end
end

class StringInquirer
	attr_accessor :string
	
	def initialize(str)
		@string = str
	end

	def method_missing(symbol)
 		if symbol.to_s =~ /\w+\?/
 			string == symbol.to_s.chop
 		else
      super
    end
	end

	def respond_to?(symbol)
		if symbol.to_s =~ /\w+\?/
      		true
  	 	 else
     		 super
   		 end
	end
end
 
 class String
 	def inquiry
 		StringInquirer.new(self)
 	end
 end

# a = []
# a << ["", nil, false]
# a << ""
# a << {}
# a << false
# a << nil
# p a
# p a.blank?
# p a.present?

# h = {}
# p h.blank?
# p h.present?

# s = String.new(" ")
# p s.blank?
# p s.present?


# f = 2
# p f.try(:succ)
# p f.try { |x| x.succ.to_s * 5}

# si = StringInquirer.new("panda")
# p si.pandaa?
# p si.panda?
# p si.respond_to? :panda?
# p si.respond_to? :pandaa?

# p "production".inquiry.production?
# p "active".inquiry.inactive?       