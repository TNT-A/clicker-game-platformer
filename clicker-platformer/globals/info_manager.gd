extends Node

var selected_character : String  = "default"
var selected_difficulty : String = "easy"

var clicker_panel
var player

var base_player_health : int = 10
var base_max_player_health : int = 10
var player_health : int = 10
var player_max_health : int = 10

var click_power = 1
var autoclick_power = 1
var gold = 1000

var floor_num : int = 0

#Saves abilities in ability panel
#{ability type, active, slot, damage level, power level, clicker_level, length_level}
var saved_panel : Array = [
	
]

var default_panel : Array = [
	#{
	#"ability_type" = 3,
	#"active" = truew,
	#"slot" = 0,
	#"damage_level" = 100,
	#"power_level" = 100,
	#"clicker_level" = 3,
	#"length_level" = 0,
	#"rarity" = 0
	#}, 
	#{
	#"ability_type" = 1,
	#"active" = true,
	#"slot" = 1,
	#"damage_level" = 0,
	#"power_level" = 0,
	#"clicker_level" = 0,
	#"length_level" = 0,
	#"rarity" = 0
	#}, 
	preload("res://clicker_panel/resources/resource_folder/ability_god_shot.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability2.tres")
]

func _ready() -> void:
	SignalBus.register_panel.connect(register_panel)
	SignalBus.register_player.connect(register_player)
	start_run()

func start_run():
	saved_panel = default_panel
	player_health = player_max_health

func register_panel(panel):
	clicker_panel = panel

func register_player(pot_player):
	player = pot_player
