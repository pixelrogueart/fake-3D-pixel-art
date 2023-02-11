extends Node

func _init():
	game_signals.connect("spawn_obj_fx",self,"spawn_fx_at_obj")

func spawn_fx_at_obj(pos,fx,obj):
	var effect = load(game_libraries.effects_library[fx]).instance()
	obj.add_child(effect)
	effect.global_position.x = pos.x + rand_range(-2,2)
	effect.global_position.y = pos.y
