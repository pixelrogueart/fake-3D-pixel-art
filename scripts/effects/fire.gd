extends Node2D


onready var sprites = []
export (String) var fire_folder
export (int) var frame_num
onready var animation = $animation
onready var sprite = $sprite

func _ready():
	randomize()
	sprites = read_folder(fire_folder)
	sprite.hframes = frame_num
	var file = randi() % sprites.size()
	sprite.texture = sprites[file]
	animation.play("fire")
	var scale = rand_range(0.8,1)
	self.scale = Vector2(scale,scale)
func read_folder(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(".png"):
				var image = load(path + file)
				files.append(image)
	dir.list_dir_end()
	return files

func _on_animation_animation_finished(anim_name):
	self.queue_free()
