class String
	def to_py
		self
	end
end

class Code
	attr_accessor :code
	attr_accessor :level
	def initialize(code,level)
	 	 @code = code	
	  	 @level = level
	end

	def to_py
		return add_tab(@code)	
	end
	
	def add_tab(elem)
		if elem.kind_of?(String)
			return "\t"*@level+elem.to_s
		end
		return code.map{|l| "\t"*@level+elem.to_s}	
	end

end

class Def < Code
	attr_accessor :name
	
	def initialize(name, code, level)
		@name = name	
		@level = level
		@code = parse_code(code, @level+1) 
	end

	def to_py
		ret = add_tab("def #{@name}():\n")
		ret << code.map{|l| l.to_py}.join("\n")
		ret
	end
end

class BooleanOp < Code
	attr_accessor :operator
	def initialize(operator, code, level)
		@operator = operator
		@code = parse_code(code,level+1)
		@level = level
	end

	def to_py

		ret = "\n"
		ret << add_tab("(\n")
		ret << @code.map{|l| [add_tab(l.to_py),add_tab(@operator)]}.flatten[0..-2].join("\n")
		ret << "\n"
		ret << add_tab(")\n")
		ret	
	end

end


class Primitive < Code
	attr_accessor :type, :center, :x, :y, :z, :radius
end

class Sphere < Primitive
	def initialize(radius)
		@radius = radius
	end

	def to_py
		ret = add_tab("Sphere(#{radius})")	
	end
end

class Cube < Primitive
	def initialize(x,y,z,level,center=false)
		@x = x
		@y = y
		@z = z
		@center = center	
		@level = level
	end
	
	def to_py
		ret = "Box(#{x},#{y},#{z}"
		if @center == true
			ret << ",center=True"
		end
		ret <<")"
		return add_tab(ret)
	end
end
