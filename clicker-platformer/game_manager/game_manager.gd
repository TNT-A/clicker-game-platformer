extends Node
class_name GameManager

var room_started : bool = false
var current_room : RoomBase

#@onready var main_character: Player = $MainCharacter
#@onready var room_controller: RoomController = $RoomController
#@onready var enemy_controller: Node2D = $EnemyController
#@onready var projectile_hub: ProjectileHub = $ProjectileHub
#@onready var boss_controller: BossController = $BossController
@onready var projectile_hub: ProjectileHub = $SubViewportContainer/SubViewport/ProjectileHub
@onready var room_controller: RoomController = $SubViewportContainer/SubViewport/RoomController
@onready var boss_controller: BossController = $SubViewportContainer/SubViewport/BossController
@onready var enemy_controller: Node2D = $SubViewportContainer/SubViewport/EnemyController
@onready var main_character: Player = $SubViewportContainer/SubViewport/MainCharacter
@onready var screen_transitioner: ColorRect = $UILayer/ScreenTransitions/ScreenTransitioner
@onready var screen_transitions: ScreenTransitions = $UILayer/ScreenTransitions

@onready var pause_menu: PauseMenu = $UILayer/PauseMenu

@export var area_resource : AreaResource 

func _ready() -> void:
	$UILayer/LoseScreen.visible = false
	print("Current char is: ", InfoManager.selected_character)
	print("Current Difficulty is: ", InfoManager.selected_difficulty)
	SignalBus.room_started.connect(set_room)
	SignalBus.boss_room_started.connect(set_room)
	SignalBus.player_die.connect(lose_game)
	SignalBus.frame_freeze.connect(frame_freeze)
	SignalBus.floor_started.connect(set_initial_player_pos)
	SignalBus.swap_by_slot.connect(player_room_transition)
	SignalBus.swap_to_shop.connect(finish_level)
	SignalBus.game_end.connect(to_start)
	SignalBus.register_manager.emit(self)
	setup()
	screen_transitions.transition_to()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if pause_menu.is_opened:
			pause_menu.close_menu()
		else:
			pause_menu.open_menu()

func setup():
	if !InfoManager.saved_area_resource:
		area_resource = InfoManager.starting_area_resource
	else:
		area_resource = InfoManager.saved_area_resource
	if !area_resource:
		print("NO AREA RESOURCE!!!!")
		set_new_area()
	InfoManager.saved_area_resource = area_resource
	InfoManager.current_floor_num += 1
	
	room_controller.area_resource = area_resource
	enemy_controller.area_resource = area_resource
	room_controller.setup()
	enemy_controller.setup()

func set_new_area():
	area_resource = InfoManager.total_area_list.pick_random()
	print("Next area set!")

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

func finish_level():
	process_floor()
	save_info()
	to_shop()

func process_floor():
	if InfoManager.current_floor_num >= area_resource.base_floor_nums:
		InfoManager.total_area_num += 1
		InfoManager.current_floor_num = 0
		set_new_area()

func save_info():
	InfoManager.saved_area_resource = area_resource
	SignalBus.floor_ended.emit()

#func transition_away():
	#var transition_time : float = .4
	#var tween = create_tween()
	#tween.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.5, transition_time)
	#await get_tree().create_timer(transition_time + .2).timeout
	#return true
#
#func transition_to():
	#var transition_time : float = .4
	#screen_transitioner.material
	#screen_transitioner.material.set_shader_parameter("progress", 0.5)
	#var tween_on = create_tween()
	#tween_on.tween_property(screen_transitioner.material, "shader_parameter/progress", 0.0, transition_time)

func to_shop():
	await screen_transitions.transition_away()
	get_tree().change_scene_to_file("res://run_shop/run_shop.tscn")

func lose_game():
	$UILayer/LoseScreen.visible = true

func _on_lose_button_pressed() -> void:
	to_start()

func to_start():
	await screen_transitions.transition_away()
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
