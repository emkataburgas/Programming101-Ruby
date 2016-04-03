class Object
	def singleton_class
		case self
		when Fixnum
			raise TypeError
		when Symbol
			raise TypeError
		when nil 
			NilClass
		when true
			TrueClass
		when false
			FalseClass
		else
			class << self
				self
			end
		end
	end

	def define_singleton_method(method_name, &block)
		singleton_class.send(:define_method, method_name, &block)
	end

  def delegate(method_name, to:)
    class_eval <<-RUBY
      def #{method_name}(*args, &block)
        #{to}.#{method_name}(*args, &block)
      end
      RUBY
  end
end

class String
	def to_proc
		methods = self.split('.')

		proc do |arg, *args| 
			methods.each { |method| arg = arg.send(method) } 
			arg
		end
	end
end

class Module
	def private_attr_reader (*args)
		args.flatten.each do |arg|
			define_method(arg) { instance_variable_get "@#{arg}" }
			private arg
		end	
	end


	def private_attr_writer (*args)
		args.flatten.each do |arg|
			method_name = arg.to_s + "="
			define_method(method_name) { |value| instance_variable_set "@#{arg}", value }
			private method_name
		end
	end

	def private_attr_accesssor(*args)
		private_attr_writer (args)
		private_attr_reader (args)
	end
	
	private_attr_accesssor :emo, :pesho
end


class Module
	def cattr_reader(symbol, &block )
    singleton_class.class_eval do
	   	define_method(symbol) do 
        value = block.call 
        class_variable_set "@@#{symbol}", value

        class_variable_get "@@#{symbol}" 
      end
      
	  end
  end

	def cattr_writer(symbol, &block)
    singleton_class.class_eval do
  		method_name = symbol.to_s + "="
		  define_method(method_name) do |value| 
        if block
          value = block.call 
          class_variable_set "@@#{symbol}", value
        else
          class_variable_set "@@#{symbol}", value 
        end
      end
    end 
  end

	def cattr_accessor(symbol, &block)
		cattr_writer(symbol, &block)
		cattr_reader(symbol, &block)
	end
end

class TestCase
	cattr_accessor(:tests) { 3 }
end

class NilClass
  def method_missing(*)
    nil
  end
end

class Proxy
  def initialize(arg)
    @arg = arg
  end

  def method_missing(symbol)
    @arg.send(symbol)
  end

  def respond_to_missing?(method, *)
    @arg.respond_to? method
  end
end


=begin
nil.singleton_class
:a.singleton_class
2.singleton_class
true.singleton_class
false.singleton_class
p Object.new.singleton_class
o = Object.new
o.define_singleton_method(:say_hi) { 42 }
p o.say_hi
p [2, 3, 4, 5].map(&'succ.succ.succ') #=> [5, 6, 7, 8]
puts "------Module-------"
mod = Module.new
mod.send(:emo=, "opa")
mod.send(:pesho=, "stana")
p mod.send(:emo)
p mod.send(:pesho)
puts "-------------------"
p TestCase.tests
p nil.asdas.adsf.dsaf
proba = Proxy.new ([1,2,3,4,5])
p proba.respond_to? :sizes
=end

User = Struct.new(:first_name, :last_name)

class Invoce
  delegate :first_name, to: '@user'
  delegate :last_name, to: '@user'

  def initialize(user)
    @user = user
  end
end

user = User.new 'Genadi', 'Samokovarov'
invoice = Invoce.new(user)

p invoice.first_name #=> "Genadi"
p invoice.last_name #=> "Samokovarov"