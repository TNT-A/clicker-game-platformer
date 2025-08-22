extends Node2D

var room_list : Array[PackedScene] = [
	preload("res://maps/map_list/floor1/og_room1.tscn")
]

var reward_rooms : Array[PackedScene] = [
	preload("res://maps/map_list/floor1/og_room1.tscn")
]

@onready var layers : Array = [
	$Layer1, 
	$Layer2, 
	$Layer3, 
	$Layer4, 
	$Layer5
]

@onready var reward_layers : Array = [
	$Layer1/RewardLayer1, 
	$Layer2/RewardLayer2, 
	$Layer3/RewardLayer3, 
	$Layer4/RewardLayer4, 
	$Layer5/RewardLayer5
]

func _ready() -> void:
	load_levels()
	generate_rewards()

func load_levels():
	for layer in layers:
		var new_room = room_list.pick_random().instantiate()
		layer.add_child(new_room)

func generate_rewards():
	for layer in reward_layers:
		var new_room = reward_rooms.pick_random().instantiate()
		layer.add_child(new_room)
