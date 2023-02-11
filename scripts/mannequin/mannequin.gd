extends KinematicBody2D
onready var skin = $skin
var interact_displayer

func _on_interactive_area_body_entered(body):
	if body is Player:
		if body.interact_area.active_object == self:
			skin.body.material.set_shader_param("hit_opacity",0.5)
			var displayer = game_libraries.interact_nodes["change_skin"].instance()
			interact_displayer = displayer
			interact_displayer.rect_position.y -= 10
			self.add_child(displayer)
			
func _on_interactive_area_body_exited(body):
	if body is Player:
		skin.body.material.set_shader_param("hit_opacity",0)
		if interact_displayer:
			interact_displayer.queue_free()
