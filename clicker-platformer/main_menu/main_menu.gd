extends Control

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

func _ready() -> void:
	update_menu()

#Game Select
func _on_button_pressed() -> void:
	start_game()

func _on_button_2_pressed() -> void:
	print("No settings yet")

func _on_button_3_pressed() -> void:
	print("No exit yet")

func start_game():
	get_tree().change_scene_to_file("res://hub/hub.tscn")

#Option Select
func update_menu():
	$OptionSelect/Character/CenterContainer/HBoxContainer/TextureRect.texture = char_textures[current_char]
	$OptionSelect/Difficulty/CenterContainer/HBoxContainer/Label.text = difficulty_list[current_difficulty]

#Difficulty Select
func _on_difficulty_down_pressed() -> void:
	current_difficulty -= 1
	if current_difficulty < 0:
		current_difficulty = len(difficulty_list)-1
	update_menu()

func _on_difficulty_up_pressed() -> void:
	current_difficulty += 1
	if current_difficulty > len(difficulty_list)-1:
		current_difficulty = 0
	update_menu()

#Character Select
func _on_character_down_pressed() -> void:
	current_char -= 1
	if current_char < 0:
		current_char = len(char_list)-1
	update_menu()

func _on_character_up_pressed() -> void:
	current_char += 1
	if current_char > len(char_list)-1:
		current_char = 0
	update_menu()
