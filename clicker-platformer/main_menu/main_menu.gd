extends Control

@onready var screen_transitions: ScreenTransitions = $ScreenTransitions
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

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
	#ProjectSettings.set_setting("rendering/environment/defaults/default_clear_color", Color.BLACK)
	RenderingServer.set_default_clear_color(Color.BLACK)
	screen_transitions.transition_to()

#Game Select
func _on_button_pressed() -> void:
	await screen_transitions.transition_away()
	start_game()

func _on_hub_button_pressed() -> void:
	#var tween = get_tree().create_tween()
	#tween.tween_property(audio_stream_player, "volume_linear", 0, .6)
	await screen_transitions.transition_away()
	start_hub()

func start_game():
	InfoManager.selected_character = char_list[current_char]
	InfoManager.selected_difficulty = difficulty_list[current_difficulty]
	InfoManager.gold = 50
	InfoManager.click_power = 1
	InfoManager.start_run()
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")

func start_hub():
	get_tree().change_scene_to_file("res://hub/hub.tscn")
