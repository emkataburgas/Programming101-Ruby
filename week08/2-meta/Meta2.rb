class Symbol
	def to_proc 
		 proc do |arg|
      arg.send(self)
     end
	end
end

class Fixnum
  alias_method :multiply, :*

  def *(other_number)
    if (self == 6 and other_number == 9) or ( self == 9 and other_number == 6 )
      42
    else
      self.multiply(other_number)
    end
  end
end

# class Object
#   def &
#     if nil?
#       nil 
#     else
#       self.class.class_eval <<-RUBY
#       def method_missing(arg)
#         p arg
#         nil 
#       end
#       RUBY
#     end
#   end
# end

class Class
  def method_around(method_name) do |obj = self , invoke = method_name, *args|
      obj.send(invoke,*args)
    end

  end
end

p [1,2,3].map(&:odd?)
p 6*8 

# user = Object.new
# p user.&.assignments.&.asd

array = Array.new
array.method_around(:insert)  