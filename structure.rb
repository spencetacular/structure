=begin
This code generates position and angel data for a 3D structure that is based off of 
catenaty curve.  Basically it creates a list of triangle data that can me imported into
a 3D modeling program for rendering, I am using Maya 3D.  The numbers for level_heights_data 
and level_diameters_data where generated using the standard euquation for a catenary curve
which is y = a * cosh(x/a)  https://en.wikipedia.org/wiki/Catenary
In this particular case I am using a = 1.5.  Hopefully future versions will automate this process.
=end

# Number of sides around the pase of the structure
num_sides = 13

#Ratio of the diameter of the structure to the height of the first level
#ratio =  23.0 / 80.0 

#The Diameter of the structure at the base
diameter = 80.0

# Actual measurements for each level of the structure
level_heights_data = [23.0, 16.0, 13.0, 11.0, 9.0, 7.0, 4.877, 5.0]
level_diameters_data = [ 81.344, 76.820, 70.09, 63.001, 52.659, 42.422, 29.547, 13.034, 5.0]
#diameter = level_diameters_data.max

@ratio = diameter/level_diameters_data.max
# Create a file to wirite data to.
out_file = File.new("about_data.txt", "w")
structure_file = File.new("structure_data.txt", "w")
heights_file = File.new("heights_data.txt", "w")
diameters_file = File.new("diameters_data.txt", "w")
triangles_file = File.new("triagnles_data.txt", "w")

out_file.write("Number of sides:\n ")
out_file.write(num_sides.to_s + "\n")
out_file.write("Number of levels:\n ")
out_file.write(level_heights_data.count.to_s + "\n")
 
structure_file.write(num_sides.to_s + "\n")
structure_file.write(level_heights_data.count.to_s + "\n")

  def calc(diameter_base, diameter_top, level_height, num_sides)
  
    # divide by 2 ?
  	d = (diameter_base - diameter_top) / 2
    puts d
    tilt =  Math.tanh( d / level_height ) * 180.0 / Math::PI
    #d = d/2

    

  	#length_long = Math.sqrt(d ** 2 + level_height ** 2)
  	
  	angle = (360.0 / num_sides.to_i / 2.0) * Math::PI / 180.0
  	r = diameter_base / 2
  	length_short  = 2 * r * Math.sin(angle)
  	
 	#@aplha = Math.cosh( (@length_short / 2.0 ) / @length_long) * 180.0 / Math::PI
  	l = length_short/2

    l_2 = Math.sqrt(level_height **2 + d **2)
    length_long = Math.sqrt(l_2 ** 2 + l ** 2)
    puts "level_height: #{level_height}"
    puts "length_long: #{length_long}"


    #@alpha = Math.sinh(0.5) * 180.0 / Math::PI

    a =   Math.sinh(l/length_long) * 180.0 / Math::PI

  	
  	
  	return length_long, length_short, a, tilt
  end

  	

#tri = Triangle.new(81.344, 76.820, 23.0, 13)
#tri.calc()





# Ratios of the measeurements so that object can be scaled up or down
level_heights = Array.new(level_heights_data.count)
level_diameters = Array.new(level_diameters_data.count)




@i = 0
# Scale the level_heights according to the diameter at the base
out_file.write("Level Heights:\n")
until @i >= level_heights_data.count  do
 # level_heights[@i] = level_heights_data[@i] / level_heights_data.first * @ratio 
 level_heights[@i] = level_heights_data[@i] * @ratio
  out_file.write(level_heights[@i])
  out_file.write("\n")

  heights_file.write(level_heights[@i])
  heights_file.write("\n")
 # puts level_heights[@i]
  @i +=1;
end

@i =0

# Scale the level_diameters according to the diameter at the base
out_file.write("Level Diameters:\n")
until @i >= level_diameters_data.count do
  level_diameters[@i] = level_diameters_data[@i] * @ratio
  out_file.write(level_diameters[@i])
  out_file.write("\n")

  diameters_file.write(level_diameters[@i])
   diameters_file.write("\n")
  #puts level_diameters[@i]
  @i+=1;
end

@i = 0



until @i >= level_heights_data.count  do
	
	#puts "Triangle level #{@i}"
	values = calc(level_diameters[@i], level_diameters[@i +1], level_heights[@i], num_sides).to_s.tr('[]','').tr(',',"\n")
	out_file.write("Triangle level #{@i}: \n")
	out_file.write(values)
	out_file.write ("\n")

  triangles_file.write(values)
  triangles_file.write ("\n")


	@i+=1;
	
end

out_file.close	
structure_file.close
heights_file.close
diameters_file.close
triangles_file.close

  