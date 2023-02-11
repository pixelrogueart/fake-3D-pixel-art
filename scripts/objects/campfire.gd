extends StaticBody2D

var min_time = 0.1
var max_time = 0.2
onready var timer = $timer

func _ready():
	randomize()

func _on_timer_timeout():
	timer.wait_time = rand_range(min_time,max_time)
	game_signals.emit_signal("spawn_obj_fx",self.global_position,"fire",self)
