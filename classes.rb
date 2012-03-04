class Code
	attr_accessor :code
	def initialize(code)
		 @code = code	
	end

	def to_py
		return @code	
	end
end

class Def < Code
	attr_accessor :name
	
	def initialize(name, code)
		@name = name	
		@code = parse_code(code) # array with more stuff
	end

	def to_py
		ret = "def #{@name}():"
			
	end
end


class Primitive < Code
	attr_accessor :type, :center
end

class Cube < Primitive
	attr_accessor :x, :y, :z
	def initialize(x,y,z,center)
		@x = x
		@y = y
		@z = z
		@center = center	
	end
end
