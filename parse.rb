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
#		puts "i=#{i} skip_until=#{skip_until}"		
		if i <= skip_until
			next 	
		end

		if elem == "{"			
			inside_code, skip_until = find_code_inbetween(code[i+1..-1])			
			elements << parse_req(inside_code, level+1)
#			puts elements.inspect			
			next
		end
		if elem == "}"
			next
		end
		elements << elem
	}
		
	return elements			
end

def parse_code(elements)
	code = []
	skip_until = -1
	
	elements.each_with_index do |element, i| 
		if i <= skip_until
			next	
		end		
			
		if element[0..5] == "module"
			skip_until = i+1
			code << Def.new(element[7..1].strip.gsub("(","").gsub(")",""), elements[i+1])
			next
		end


		code << element
	end


	return code	
end

tree = parse_req(res)
code = parse_code(tree)


puts code.inspect


