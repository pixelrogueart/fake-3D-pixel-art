#made by @pixelrogueart, follow me on twitter, instagram, tumblr, newgrounds and tiktok!
#any questions join my discord: https://discord.gg/Q9VMwds4tX

#also sorry if it's a mess, I'm still learning how to code properly!

extends Node2D

export (Resource) var skin; #variable for the skin you want to use
export (Resource) var map; #variable for the UV map for your character
onready var body = $body
var source_file_coordinates = [] #array to store the coordinates in vector2
var source_files = [] #array to store the raw images
var map_coordinates = {} #dictionary to store the xy of each pixel along with the color in the position
var skin_colors = {} #dictionary to store the xy of each pixel along with the color in the position of the current skin
var new_map_test = []

func _ready():
	map = load_image(map.get_path()) #load the map as a raw png by referencing the path to the uv map png
	map_coordinates = grab_map(map) #grab the coordenates for the uv map and store into a dictionary
	skin = load_image(skin.get_path()) #load skin as a raw png by referencing the path to the skin png
	skin_colors = grab_map(skin) #grab the skin coordenates and store into a dictionary
	var image =$body.texture
	image = load_image(image.get_path())
	source_file_coordinates = map_image(image)
	apply_colors(image)

func load_image(source): #tunrs the reference source png into a raw png
	var image = Image.new() #creates a new image
	var err = image.load(source) #load the source in the the image
#	if err != OK:
#		print("image load failed")
#	else:
#		print("image loaded")
	return image #returns the image as a raw png

func grab_map(image): #function to map each pixel of an image by it's xy coordinate and color in that value
	var width = image.get_width() #grab the image width
	var height = image.get_height() #grab the image height
	var coordinates = {} #new dictionary to store vector 2 and color variables
	image.lock() #lock the image, still not sure why I need to do this honestly
	var cell_x = 0 #current x position
	var cell_y = 0 #current y position
	var cur_pos = Vector2() #current position in vector 2
	for pixel in width*height: #for each pixel in width * height
		cur_pos = Vector2(cell_x,cell_y) #set the vector 2 to cell_x and cell_y
		var cur_pixel = image.get_pixelv(cur_pos) #grab the colors in that pixel by referencing the vector 2 current position 
		if cur_pixel != Color(0,0,0,0): #if the current pixel is not an empty pixel
			coordinates[cur_pos] = cur_pixel #creates a new key inside the dictionary containing the position we are and the value in the key is the color in rgb 
		if cell_x >= width - 1: #if the current search X pixel is higher than the image width
			cell_x = 0 #sets it to 0, restarting the search
			cell_y += 1 #and jump one pixel down
		else: 
			cell_x +=1 #if not, just keeps going
	return coordinates #returns all the pixels and rgb values in this image

func map_image(image): #this function might be redundant, but it's a little different from the previous function, feel free to make it better
	var width = image.get_width() #grab the image width
	var height = image.get_height()#grab the image height
	var coordinates = {} #new dictionary to store vector 2 and color variables
	image.lock() #lock the image
	var cell_x = 0 #current x position
	var cell_y = 0 #current y position
	var cur_pos = Vector2() #current position in vector 2
	for pixel in width*height: #for each pixel in width * height
		cur_pos = Vector2(cell_x,cell_y)  #set the vector 2 to cell_x and cell_y
		var cur_pixel = image.get_pixelv(cur_pos) #grab the colors in that pixel by referencing the vector 2 current position 
		if cur_pixel != Color(0,0,0,0):#if the current pixel is not an empty pixel
			if cur_pixel in map_coordinates.values(): #if the color of the pixel is the map coordinates dictionary
				coordinates[cur_pos] = cur_pixel #creates a new key inside the dictionary containing the position we are and the value in the key is the color in rgb 
		if cell_x >= width - 1: #if the current search X pixel is higher than the image width
			cell_x = 0 #sets it to 0, restarting the search
			cell_y += 1 #and jump one pixel down
		else: 
			cell_x +=1 #if not, just keeps going
	return coordinates #returns all the pixels and rgb values in this image

func apply_colors(image): #shift each pixel by grabbing the image, current index and the animation name
	var new_map = [] #new array of colors for the image
	for vec2 in skin_colors.keys(): # search every key in the skin dictionary
		if vec2 in map_coordinates: # check if the key is in the map_coordinates
			for pos in source_file_coordinates: #search each vector2 inside the current image coordinates
					if source_file_coordinates[pos] == map_coordinates[vec2]: #if the color is the same as the uv map
						new_map.push_back([pos,skin_colors[vec2]]) #pushes back the vector2 position and the color
	for i in new_map.size(): #for each position in the array of the new colors
		image.lock() #lock the image
		image.set_pixelv(new_map[i][0],new_map[i][1]) #set each pixel as the referenced color from the skin map
	image.unlock() #unlock the image, not sure why
	var tex = ImageTexture.new() #creates a new image texture
	tex.create_from_image(image,0) #updates the image texture by grabbing the raw png
	new_map_test = new_map
	$body.texture = tex
