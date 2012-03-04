#!/usr/bin/env ruby

require "classes"

f = File.read(ARGV[0]);
# remove formatting
res = f.gsub("\n","").gsub("\r","").gsub("\t","")
# make an array by ; to split out the code; 
# add ; before and after { and } to get them seperated too
res = res.gsub("{",";{;").gsub("}",";};").split(";")
res.delete("") # remove emtpy lines


def find_code_inbetween(code)
	index = 0
	level = 1
	elements=[]
	code.each do |elem|
		index+=1
		level+=1 if elem == "{"
		level-=1 if elem == "}"		
		return [elements,index] if level == 0
		elements << elem
	end	

end



def parse_req(code, level = 0)
	elements = []
	skip_until=-1

	code.each_with_index{|elem, i|		

#		puts "i=#{i} skip_until=#{skip_until}" if level == 2		
		if i <= skip_until
			next 	
		end

		if elem == "{"			
			inside_code, skip_until = find_code_inbetween(code[i+1..-1])	
			skip_until += i		
			elements << parse_req(inside_code, level+1)
			next
		end
		if elem == "}"
			next
		end
		elements << elem
	}
#	puts "level #{level} returning: "+elements.inspect		
	return elements			
end

def parse_code(elements,level=0)
	code = []
	skip_until = -1

	elements.each_with_index do |element, i| 
		if i <= skip_until
			next	
		end		
			
		if element[0..5] == "module"
			skip_until = i+1
			
			code << Def.new(element[7..-1].strip.gsub("(","").gsub(")",""), elements[i+1], level)
			next
		end

		if element[0..9] == "difference"
			code << BooleanOp.new("-", elements[i+1], level)
			skip_until = i+1
			next
		end

		if element[0..4] == "union"
			code << BooleanOp.new("+", elements[i+1], level)
			skip_until = i+1
			next
		end

		if element[0..3] == "cube"
			x,y,z = element[element.index("[")+1..element.index("]")-1].split(",")
			if element.gsub(" ","").include?("center=true")
				center = true
			else
				center = false
			end
						
			code << Cube.new(x.to_i, y.to_i, z.to_i, level, center)		
			next
		end

		


		code << element
	end


	return code	
end

#puts res.inspect
tree = parse_req(res)
code = ""
parse_code(tree).each{|l| 
		
	if l.respond_to?("to_py")
	   code << l.to_py
	   code << "\n"
	else
	   code << l
	end
}

#puts tree.inspect

puts code


