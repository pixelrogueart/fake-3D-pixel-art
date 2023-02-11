class_name Player
extends KinematicBody2D

var gravity = 4
var velocity = Vector2()
var cur_dir = "down"
onready var animations = $animations
onready var player_sprite = $skin
onready var skin = $skin
onready var clothing = $clothing
onready var states = $state_manager
onready var interact_area = $interact_area
export (bool) var is_mannequin = false
func _ready() -> void:
	states.init(self)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
func update_direction():
	for children in skin.get_children():
		children.texture = skin.animation_files[animations.get_current_animation()][game_libraries.anim_directions[cur_dir]]
	for children in clothing.get_children():
		children.animation = cur_dir

func _verify_direction() -> int:
	if velocity.x < -0.5:
		if velocity.y > 0:
			cur_dir =  "down-left"
		elif velocity.y < 0:
			cur_dir = "up-left"
		elif velocity.y == 0:
			cur_dir = "left"
	elif velocity.x > 0.5:
		if velocity.y > 0:
			cur_dir = "down-right"
		elif velocity.y < 0:
			cur_dir = "up-right"
		elif velocity.y == 0:
			cur_dir = "right"
	elif velocity.x == 0:
		if velocity.y > 0:
			cur_dir = "down"
		elif velocity.y < 0:
			cur_dir = "up"
	return cur_dir

func move():
	velocity = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_raw_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_raw_strength("ui_up")
		).normalized()
