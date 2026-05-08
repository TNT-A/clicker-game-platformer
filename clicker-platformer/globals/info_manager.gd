extends Node

var selected_character : String  = "default"
var selected_difficulty : String = "easy"

var clicker_panel
var player

var base_player_health : int = 5
var base_max_player_health : int = 5
var player_health : int = 5
var player_max_health : int = 5

var click_power = 1
var autoclick_power = 1
var gold = 1000

var floor_num : int = 0

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
	#start_run()

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
