extends Node2D
class_name GameManager

var room_started : bool = false
var current_room : RoomBase

@onready var main_character: Player = $MainCharacter
@onready var room_controller: RoomController = $RoomController
@onready var enemy_controller: Node2D = $EnemyController

func _ready() -> void:
	$UILayer/WinScreen.visible = false
	$UILayer/LoseScreen.visible = false
	print("Current char is: ", InfoManager.selected_character)
	print("Current Difficulty is: ", InfoManager.selected_difficulty)
	SignalBus.room_started.connect(set_room)
	SignalBus.room_ended.connect(end_game)
	SignalBus.player_die.connect(lose_game)
	SignalBus.frame_freeze.connect(frame_freeze)
	SignalBus.floor_started.connect(set_initial_player_pos)
	SignalBus.swap_by_slot.connect(player_room_transition)
	SignalBus.swap_to_shop.connect(finish_level)

func set_initial_player_pos():
	#print("setting the position")
	var first_room : RoomBase = room_controller.room_bases[0]
	main_character.global_position = first_room.player_spawn.global_position

func player_room_transition(current_slot : int, to_slot : int):
	var to_room : RoomBase = room_controller.room_bases[to_slot - 1]
	main_character.global_position = to_room.player_spawn.global_position

func frame_freeze(timescale: float, duration: float):
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func set_room(room):
	room_started = true
	current_room = room
	#print("I'm a room started")

func end_game(room_slot, room):
	pass
	#if current_room.final_room:
		#print("You win yippee")
		#$UILayer/WinScreen.visible = true

func finish_level():
	save_info()
	to_shop()

func save_info():
	InfoManager.floor_num += 1
	SignalBus.floor_ended.emit()

func to_shop():
	get_tree().change_scene_to_file("res://run_shop/run_shop.tscn")

func lose_game():
	$UILayer/LoseScreen.visible = true

func _on_win_button_pressed() -> void:
	finish_level()

func _on_lose_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
