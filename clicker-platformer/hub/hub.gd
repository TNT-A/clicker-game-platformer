extends Node2D

var current_char : int = 0
var char_list : Array = [
	"default"
]
var char_textures : Array = [
	preload("res://sprites/cursor/cursor_incremelee.png")
]

var current_difficulty : int = 0
var difficulty_list : Array = [
	"medium",
]

func start_game():
	InfoManager.selected_character = char_list[current_char]
	InfoManager.selected_difficulty = difficulty_list[current_difficulty]
	InfoManager.gold = 50
	InfoManager.click_power = 1
	InfoManager.start_run()
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_game()
