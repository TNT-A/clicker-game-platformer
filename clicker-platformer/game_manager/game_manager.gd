extends Node2D
class_name GameManager

var room_started : bool = false
var current_room : Room
var current_enemies_to_spawn : int = 3
var currrent_select_enemy_num : int = 3
var current_spawn_type : String = "All" #There is "All" and "Continuous"

var enemy_list_1 : Array[PackedScene] = [
	preload("res://enemies/enemies/ufo/ufo_enemy.tscn"),
	preload("res://enemies/enemies/bully_box/bully_box.tscn"),
	preload("res://enemies/enemies/walker/walker_enemy.tscn"),
	preload("res://enemies/enemies/bounce_enemy/BounceEnemy.tscn"),
	preload("res://enemies/enemies/follow_shoot/follow_shoot.tscn")
]

func _ready() -> void:
	$UILayer/WinScreen.visible = false
	$UILayer/LoseScreen.visible = false
	print("Current char is: ", InfoManager.selected_character)
	print("Current Difficulty is: ", InfoManager.selected_difficulty)
	SignalBus.room_started.connect(set_room)
	SignalBus.room_ended.connect(end_game)
	SignalBus.player_die.connect(lose_game)

func set_room(room):
	room_started = true
	current_room = room
	current_enemies_to_spawn += 1
	#print("I'm a room started")

func end_game(num, room):
	if current_room.final_room:
		print("You win yippee")
		$UILayer/WinScreen.visible = true

func lose_game():
	$UILayer/LoseScreen.visible = true

func _on_win_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_lose_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
