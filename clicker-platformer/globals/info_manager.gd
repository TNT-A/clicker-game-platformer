extends Node

var selected_character : String  = "default"
var selected_difficulty : String = "easy"

var clicker_panel
var player

var click_power = 1
var gold = 1111

var floor_num : int = 0

func _ready() -> void:
	SignalBus.register_panel.connect(register_panel)
	SignalBus.register_player.connect(register_player)

func register_panel(panel):
	clicker_panel = panel

func register_player(pot_player):
	player = pot_player
