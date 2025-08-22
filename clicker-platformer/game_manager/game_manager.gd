extends Node2D
class_name GameManager

var room_started : bool = false
var current_room : Node
var current_enemies_to_spawn : int = 3
var currrent_select_enemy_num : int = 3
var current_spawn_type : String = "All" #There is "All" and "Continuous"

var enemy_list_1 : Array[PackedScene] = [
	preload("res://enemies/enemies/test_enemy/test_enemy.tscn")
]

func _ready() -> void:
	print("Current char is: ", InfoManager.selected_character)
	print("Current Difficulty is: ", InfoManager.selected_difficulty)
	SignalBus.room_started.connect(set_room)

func set_room(room):
	room_started = true
	current_room = room
	#print("I'm a room started")
