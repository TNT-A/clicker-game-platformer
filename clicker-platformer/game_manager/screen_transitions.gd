extends Control
class_name ScreenTransitions

@onready var screen_transitioner: ColorRect = $ScreenTransitioner

func transition_away():
	var transition_time : float = .4
	var tween = create_tween()
	tween.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.5, transition_time)
	await get_tree().create_timer(transition_time + .2).timeout
	return true

func transition_to():
	
	var transition_time : float = .4
	screen_transitioner.material
	screen_transitioner.material.set_shader_parameter("progress", 0.5)
	var tween_on = create_tween()
	tween_on.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.0, transition_time)
