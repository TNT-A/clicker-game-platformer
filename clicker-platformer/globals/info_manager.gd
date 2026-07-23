extends Node

@onready var window : Window = get_window()
@onready var base_size : Vector2i = window.content_scale_size

#Add to the camera transitions to make space for the UI
var cam_pivot : Vector2 = Vector2(128, 0)

var selected_character : String  = "default"
var selected_difficulty : String = "easy"

var clicker_panel
var player : Player

var base_player_health : int = 5
var base_max_player_health : int = 5
var player_health : int = 5
var player_max_health : int = 5

var click_power = 1
var autoclick_power = 1
var gold = 1000

var starting_area_resource : AreaResource = load("res://room_controller/area_resources/test_area_resource.tres")
var saved_area_resource : AreaResource

var total_area_list : Array[AreaResource] = [
	load("res://room_controller/area_resources/test_area_resource.tres")
]
var starting_area_list : Array[AreaResource] = [
	load("res://room_controller/area_resources/test_area_resource.tres")
]
var intermediate_area_list : Array[AreaResource] = [
	load("res://room_controller/area_resources/test_area_resource.tres")
]
var final_area_list : Array[AreaResource] = [
	load("res://room_controller/area_resources/test_area_resource.tres")
]

var total_area_num : int = 0
var current_floor_num : int = 0

#Saves abilities in ability panel
#{ability type, active, slot, damage level, power level, clicker_level, length_level}
var saved_panel : Array = [
	
]

var default_panel : Array = [
	preload("res://clicker_panel/resources/resource_folder/starter_shot.tres"),
	false,
	false,
	false,
	false,
	false
]

func _ready() -> void:
	SignalBus.register_panel.connect(register_panel)
	SignalBus.register_player.connect(register_player)
	window.size_changed.connect(_on_window_size_changed)
	var min_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var min_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	window.min_size = Vector2i(min_x, min_y)
	#start_run()

func _on_window_size_changed():
	var clamped_size = window.size
	var scale = clamped_size / base_size
	window.content_scale_size = window.size

func start_run():
	print("run started")
	saved_panel.clear()
	for i in range(default_panel.size() - 1):
		saved_panel.append(default_panel.get(i))
	player_max_health = base_max_player_health
	player_health = player_max_health

func register_panel(panel):
	clicker_panel = panel

func register_player(pot_player):
	player = pot_player
