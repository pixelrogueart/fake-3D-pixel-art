extends Node
onready var states = {
	BaseState.State.Idle: $idle,
	BaseState.State.Walk: $walk,
	BaseState.State.Run: $run,
}

var player_states = {
	"idle":BaseState.State.Idle,
	"walk":BaseState.State.Walk,
	"run":BaseState.State.Run,
}

var current_state: BaseState
func _ready():
	game_signals.connect("change_player_state",self,"on_change_player_state")

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()
	current_state = states[new_state]
	current_state.enter()

func init(player: Player) -> void:
	for child in get_children():
		child.player = player
	change_state(BaseState.State.Idle)

func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)
	current_state.player.update_direction()

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state != BaseState.State.Null:
		change_state(new_state)
	current_state.player.update_direction()
func on_change_player_state(state) ->void:
	var new_state = player_states[state]
	if new_state != BaseState.State.Null:
		change_state(new_state)
