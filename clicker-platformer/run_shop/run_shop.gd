extends Node2D

@onready var screen_transitioner: ColorRect = $CanvasLayer/ScreenTransitions/ScreenTransitioner

func _ready() -> void:
	transition_to()

func transition_to():
	var transition_time : float = .4
	screen_transitioner.material
	screen_transitioner.material.set_shader_parameter("progress", 0.5)
	var tween_on = create_tween()
	tween_on.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.0, transition_time)

func transition_away():
	var transition_time : float = .4
	var tween = create_tween()
	tween.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.5, transition_time)
	await get_tree().create_timer(transition_time + .2).timeout
	return true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		to_stage()

func to_stage():
	await transition_away()
	SignalBus.floor_ended.emit()
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")
