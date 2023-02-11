#made by @pixelrogueart, follow me on twitter, instagram, tumblr, newgrounds and tiktok!
#any questions join my discord: https://discord.gg/Q9VMwds4tX

#also sorry if it's a mess, I'm still learning how to code properly!

extends Node2D

onready var states = $"../state_manager" #the state machine I'm using, you can make in another way, I just like to use a state manager to keep my character movement organized

export (Resource) var skin; #variable for the skin you want to use
export (Resource) var map; #variable for the UV map for your character

var source_file_coordinates = [] #array to store the coordinates in vector2
var source_files = [] #array to store the raw images
var map_coordinates = {} #dictionary to store the xy of each pixel along with the color in the position
var skin_colors = {} #dictionary to store the xy of each pixel along with the color in the position of the current skin
var animation_files = {} #here is where all the animation files will be stored, in case you want to use in a character movement afterwards

func _ready():
	map = load_image(map.get_path()) #load the map as a raw png by referencing the path to the uv map png
	map_coordinates = grab_map(map) #grab the coordenates for the uv map and store into a dictionary
	update_skin(skin)

func update_skin(texture):
	skin_colors.clear()
	animation_files.clear()
	skin = texture
	if texture is StreamTexture: #check if it's a stream texture, if it's not, doesn't need to load the image
		skin = load_image(skin.get_path()) #load skin as a raw png by referencing the path to the skin png
	skin_colors = grab_map(skin) #grab the skin coordenates and store into a dictionary
	for folder in states.get_children(): #loop through my states
		var path = "res://animations/%s/" %folder.name #grab the path for each folder containing all the spritesheets by using the state name
		update_source_folder(read_folder(path),folder.name) #update each folder by reading all the files, storing into an array and referencing the name of the state

func update_source_folder(files,anim_name):
	animation_files[anim_name] = [] #I create an array inside the dictionary for all the files
	for file in files.size(): #loop through the array containing each raw image file
		var file_storage #variable to store each file 
		file_storage = files[file] #store the current file being processed into a variable
		file_storage = load_image(file_storage.get_path()) #turn the image into a raw png by referencing the path
		source_files.push_back(file_storage) #push back the raw image into an array
		source_file_coordinates.push_back(map_image(file_storage)) #push back the coordinates from the current spritesheet by mapping the previously loaded raw image
	for direction in source_files.size(): #run through each direction inside the raw images array
		apply_colors(source_files[direction],direction,anim_name) #update each pixel on the current direction file
	source_file_coordinates.clear() #clear the coordinates array
	source_files.clear() #clear the source files

func read_folder(path): #funcion for reading a folder and retrieve it's files (png only but you can change for anything you'd like)
	var files = [] #files to return later
	var dir = Directory.new() #directory
	dir.open(path) #open the directory 
	dir.list_dir_begin() #starts listing all the files inside
	while true: #while still has files inside the folder
		var file = dir.get_next() #seach next file
		if file == "": #if there's no more files
			break #break the while
		elif not file.begins_with("."): #if the file doesn't starts with ., keeps going
			if file.ends_with(".png"): #if the files ends with .png (you can change by any extension you'd like)
				var image = load(path + file) #load the image by grabbing the path and the name of the file
				files.append(image) #append the file into the array
	dir.list_dir_end() #stops listing the directory
	return files #return all the images grabbed from the current folder

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

func apply_colors(image,index,anim_name): #shift each pixel by grabbing the image, current index and the animation name
	var new_map = [] #new array of colors for the image
	for vec2 in skin_colors.keys(): # search every key in the skin dictionary
		if vec2 in map_coordinates: # check if the key is in the map_coordinates
			for pos in source_file_coordinates[index].keys(): #search each vector2 inside the current image coordinates
					if source_file_coordinates[index][pos] == map_coordinates[vec2]: #if the color is the same as the uv map
						new_map.push_back([pos,skin_colors[vec2]]) #pushes back the vector2 position and the color
	for i in new_map.size(): #for each position in the array of the new colors
		image.lock() #lock the image
		image.set_pixelv(new_map[i][0],new_map[i][1]) #set each pixel as the referenced color from the skin map
	image.unlock() #unlock the image, not sure why
	var tex = ImageTexture.new() #creates a new image texture
	tex.create_from_image(image,0) #updates the image texture by grabbing the raw png
	animation_files[anim_name].push_back(tex) #push back the image texture into the animation array

