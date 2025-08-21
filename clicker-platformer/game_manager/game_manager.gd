extends Node2D

var room_started : bool = false
var current_room : Node

func _ready() -> void:
	print("Current char is: ", InfoManager.selected_character)
	print("Current Difficulty is: ", InfoManager.selected_difficulty)
	SignalBus.room_started.connect(set_room)

func set_room(room):
	room_started = true
	current_room = room
	#print("I'm a room started")
