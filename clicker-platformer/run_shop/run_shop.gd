extends Node2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		to_stage()

func to_stage():
	SignalBus.floor_ended.emit()
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")
