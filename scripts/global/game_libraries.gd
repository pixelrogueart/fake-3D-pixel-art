extends Node

var anim_directions = {
	"up": 6,
	"down": 1,
	"left": 3,
	"right": 4,
	"up-left": 5,
	"up-right": 7,
	"down-left": 0,
	"down-right": 2,
}

onready var effects_library = {
	"fire": "res://assets/effects/fire.tscn"
}


onready var interact_nodes = {
	"change_skin": preload("res://assets/ui/interact_displayer.tscn")
}
