require 'bigdecimal'
require 'bigdecimal/util' # добавя String#to_d

module Constants
	MAX_NAME_LENGTH = 40
	MAX_PRICE = 999.99
	MIN_PRICE = 0.01
	MAX_QUANTITY = 99
	MIN_QUANTITY = 1
end

class Inventory
	include Constants
	attr_reader :products
	attr_accessor :promotions, :one_free, :package, :threshold, :promotion_type_of_products, :coupons

	def initialize
		@products = {}
		@promotions = {}
		@promotion_type_of_products = {}
		@coupons = {}
		@one_free = Every_Nth_free.new
		@package = Package.new
		@threshold = Threshold.new
	end

	#register items
	def register(name, price, promotion = nil)
		#check for validity
		legit_item = false
		if name.length <= MAX_NAME_LENGTH
			if price.to_i <= MAX_PRICE and price.to_i >= MIN_PRICE
				legit_item = true
			else
				raise PriceError, "Invalid product price."
			end
		else
			raise NameError, "Product name too long."
		end
		
		#registers the item
		if products.has_key? name
			raise NameError, "There is a product registered with that name already."
		elsif legit_item
			products[name] = price
		end
		
		#creates promotion
		if legit_item and promotion
			promotion_type = promotion.keys[0]
			promotion_type_of_products[name] = promotion_type
			
			case promotion_type
			when :get_one_free
				one_free.add_item(name, promotion)
			when :package
				package.add_item(name, promotion)
			when :threshold
				threshold.add_item(name, promotion)
			end
		end
		products
	end

	#registers coupons
	def register_coupon(coupon_name, coupon_type)
		if coupon_name == 'TEATIME' || coupon_name == 'FRIENDS'
			coupons[coupon_name] = coupon_type.values[0]
		else 
			raise ArgumentError, "Only coupons named TEATIME and FRIENDS are acceptable"
		end	
	end

	#creates new cart that "knows" about the inventory
	def new_cart
		Cart.new(self)
	end

end

class Cart
	include Constants
	attr_reader :bill, :inventory, :coupon_not_used, :coupon, :data_total
	
	def initialize(inventory)
	  @inventory = inventory
		@bill = {}
		@coupon_not_used = true
		@coupon = {}
		@data_total = []
	end

	#add item to the bill
	def add(name, quantity = 1)
		if inventory.products.has_key? name
			if bill.has_key? name
				bill[name] += quantity
			else
				bill[name] = quantity
			end
		else
			raise NameError, "No such product"
		end
		bill
	end

	#checks the quantity of every item in the bill 
	def check_quantity
		bill.each_pair do |name , quantity|
			unless bill[name] <= MAX_QUANTITY and bill[name] >= MIN_QUANTITY
				raise ArgumentError, "Invalid quantity ( #{quantity} x #{name})"
			end
		end    
	end

	def total
		11
	end

	def calculate_total
		total = BigDecimal.new("0")
		data_total.each  do |element|
			total += element
		end


		if coupon.keys[0] == 'TEATIME'
			total *= coupon.values[0]
		else
			total += coupon.values[0]
		end

		if total < 0
			total = 0
		end

		total.to_digits
	end

	def invoice
		check_quantity
		puts "+------------------------------------------------+----------+"
		puts "| Name                                       qty |    price |"
		puts "+------------------------------------------------+----------+"
		bill.each_pair do |key, value|
			print_price(key, value)
			print_promotion_discount(key, value)
		end
		
		if !@coupon_not_used 
			if coupon.keys[0] == 'TEATIME' 
				discount = inventory.coupons['TEATIME']
				printf("| Coupon TEATIME - %s%% off                       |%9.2f |\n", discount, calculate_coupon_discount(discount))
			else
				discount = inventory.coupons['FRIENDS']
				reverse_sign_discount = (discount.to_d * (-1)).to_digits
				printf("| Coupon FRIENDS - %s lv. off                  |%9.2f |\n", discount, reverse_sign_discount)
			end
		end

		puts "+------------------------------------------------+----------+"
		printf("| TOTAL                                          |%9.2f |\n", calculate_total)
		puts "+------------------------------------------------+----------+"
	end

	def calculate_coupon_discount(discount)
		total_with_discount = calculate_total

		total_without_discount = 0
		total = BigDecimal.new("0")
		data_total.each  do |element|
			total_without_discount += element
		end

		total_with_discount.to_d - total_without_discount  
	end

	def print_price(key, value)
		data_total << (inventory.products[key].to_d * value).to_d
		price = (inventory.products[key].to_d * value).to_digits
		printf("| %-40s%6d |%9.2f |\n", key, value, price)
			#puts "| #{key}                                  #{value} |     #{inventory.products[key].to_i * value} |"
	end

	def print_promotion_discount(name, quantity)

			if inventory.one_free[name]
				printf("|   ( buy %1s, get 1 free )                        |%9.2f |\n", inventory.one_free[name], calculate_discount(name, quantity).to_digits)
			elsif inventory.package[name]
				percent_off = inventory.package[name].values[0]
				of_every = inventory.package[name].keys[0]
				discount = calculate_discount(name, quantity).to_digits
				printf("|   ( get %d%% off for every %d )                  |%9.2f |\n", percent_off, of_every, discount)
			elsif inventory.threshold[name]
				ordinal_suffix = get_ordinal_suffix(name)
				percent_off = inventory.threshold[name].values[0]
				after_n = inventory.threshold[name].keys[0]
				discount = calculate_discount(name, quantity).to_digits
				printf("|   ( %d%% off of every after the %d%s )           |%9.2f |\n", percent_off, after_n, ordinal_suffix, discount)
			end
	end

	def calculate_discount(name, quantity)
		promotion_type = get_promotion_type(name)
		discount = 0
		
		case promotion_type
		when :get_one_free
			nth_free = inventory.one_free[name]
			how_many_are_free = quantity / nth_free
			discount -= (inventory.products[name].to_d * how_many_are_free).to_d
		when :package
			discount_temp_hash = {}
			discount_temp_hash = discount_temp_hash.merge inventory.package[name]
			n = discount_temp_hash.keys[0]
			discount_percentage = discount_temp_hash.values[0]
			how_many_packages = quantity / n
			discount -= (inventory.products[name].to_d * how_many_packages * n * (discount_percentage / 100.0 ).to_d).to_d
		when :threshold
			threshold_temp_hash = {}
			threshold_temp_hash = threshold_temp_hash.merge inventory.threshold[name]
			threshold_number = threshold_temp_hash.keys[0]
			discount_percentage = threshold_temp_hash.values[0]
			if quantity >= threshold_number
				items_on_discount = quantity - threshold_number
				discount -= (inventory.products[name].to_d * items_on_discount * (discount_percentage / 100.0 ).to_d).to_d
			else
				0
			end 
		end 
		data_total << discount
		discount
	end

	def get_promotion_type(name)
		promotion_type = inventory.promotion_type_of_products[name]
		promotion_type
	end

	def get_ordinal_suffix(key)
				ordinal_suffix = "th"
				number = inventory.threshold[key].keys[0]
				while number != 11 and number != 12 and number != 13 
					if number / 10 > 10 
						number = number / 10
					else
						number = number % 10
						break
					end
				end
				case number
				when 1
					ordinal_suffix = "st"
				when 2
					ordinal_suffix = "nd"
				when 3
					ordinal_suffix = "rd"
				when 11
					ordinal_suffix = "th"
				when 12
					ordinal_suffix = "th"
				when 13
					ordinal_suffix = "th"
				end	 
				ordinal_suffix
	end

	def use(coupon_name)
		# rework!!
		if @coupon_not_used
			if inventory.coupons.has_key? coupon_name
				@coupon_not_used = false
				if coupon_name == 'TEATIME'
					coupon[coupon_name] = ( 100 - inventory.coupons[coupon_name]) / 100.0 
				else
					coupon[coupon_name] = (inventory.coupons[coupon_name].to_i) * (-1)
				end
			else 
				raise ArgumentError, 'The coupon you are trying to use is not registered'
			end
		else	
			raise ArgumentError, 'You are not allowed to use 2 coupons'
		end
		@coupon
	end
end

class Every_Nth_free
	attr_accessor :hash

	def initialize
		@hash = {}
	end

	def add_item(item, promotion)
		@hash[item] = promotion.values[0]
		@hash
	end

	def [](name)
		hash[name]
	end
end

class Package
	attr_accessor :hash

	def initialize
		@hash = {}
	end

	def add_item(item, promotion)
		@hash[item] = promotion.values[0]
		@hash
	end

	def [](name)
		hash[name]
	end
end

class Threshold
	attr_accessor :hash

	def initialize
		@hash = {}
	end

	def add_item(item, promotion)
		@hash[item] = promotion.values[0]
		@hash
	end

	def [](name)
		hash[name]
	end
end



inventory = Inventory.new
inventory.register 'Green Tea',    '2.79', get_one_free: 2
inventory.register 'Black Coffee', '2.99', package: {2 => 20}
inventory.register 'Milk',         '1.79', threshold: {3 => 30}
inventory.register 'Cereal',       '2.49'
inventory.register_coupon 'TEATIME', percent: 10
inventory.register_coupon 'FRIENDS', amount: '7.00'

cart = inventory.new_cart
cart.add 'Green Tea', 22
cart.add 'Black Coffee', 15
cart.add 'Milk', 17
cart.add 'Cereal', 33
cart.use 'FRIENDS'
#cart.use 'TEATIME'

puts cart.invoice

# inventory.register_coupon 'TEATIME', percent: 20

# inventory.register 'Earl Grey', '1.00', threshold: {10 => 50}
# inventory.register 'Green Tea', '1.00', get_one_free: 4
# inventory.register 'Red Tea', '1.00', package: {3 => 20}

# #cart.use 'TEATIME'
# cart.add 'Earl Grey', 10  
# cart.add 'Earl Grey', 5
# cart.add 'Earl Grey', 5
# #p cart.total 
# cart.add 'Green Tea', 3
# cart.add 'Green Tea'
# cart.add 'Green Tea'
# cart.add 'Green Tea', 3
# #p cart.total 
# cart.add 'Red Tea', 2
# cart.add 'Red Tea'
# cart.add 'Red Tea'
# #p cart.total 
# p cart.invoice