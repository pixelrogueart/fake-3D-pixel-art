class_name BaseState
extends Node

# Don't get confused, this is not the same as on the switch example
# This enum is used so that each child state can reference each other for its return value
enum State {
	Null,
	Idle,
	Walk,
	Run,
}

export (String) var animation_name
export (int) var frame_number
# warning-ignore:export_hint_type_mistmatch
export (float) var animation_speed = 1
# Pass in a reference to the player's kinematic body so that it can be used by the state
var player: Player

func enter() -> void:
	player.animations.play(animation_name)
	player.animations.playback_speed = animation_speed
	for i in player.skin.get_children():
		i.hframes = frame_number
#	player.animations.speed_scale = animation_speed
func exit() -> void:
	pass

# Enums are internally stored as ints, so that is the expected return type
# warning-ignore:unused_argument
func input(event: InputEvent) -> int:
	return State.Null

# warning-ignore:unused_argument
func process(delta: float) -> int:
	return State.Null

# warning-ignore:unused_argument
func physics_process(delta: float) -> int:
	return State.Null
