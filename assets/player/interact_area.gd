extends Area2D

var max_distance = 30 
var active_object
var objects = []
onready var player = $".."
onready var skins = $"../skin"

func _physics_process(delta):
	for i in get_overlapping_bodies():
		if not i is Player:
			if not i in objects:
				objects.push_back(i)
		for b in objects:
			if not b in get_overlapping_bodies():
				objects.pop_at(objects.find(b))
	if get_overlapping_bodies().empty():
		objects = []
	if !objects.empty():
		for i in objects:
			active_object = objects[objects.size()-1]
			
	else:
		active_object = null
func _unhandled_input(event):
	if active_object:
		if Input.is_action_just_pressed("ui_select"):
			player.skin.update_skin(active_object.skin.skin)
