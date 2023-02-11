extends BaseState

# warning-ignore:unused_argument
func enter() -> void:
	.enter()
func input(event: InputEvent) -> int:
	if Input.is_action_pressed("ui_right"):
		return State.Walk
	if Input.is_action_pressed("ui_left"):
		return State.Walk
	if Input.is_action_pressed("ui_down"):
		return State.Walk
	if Input.is_action_pressed("ui_up"):
		return State.Walk
	return State.Null

# warning-ignore:unused_argument
func physics_process(delta: float) -> int:
	player.cur_dir = player._verify_direction()
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	return State.Null
