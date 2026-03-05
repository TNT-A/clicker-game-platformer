extends Node2D

var room_size : Vector2 = Vector2(580, 292)
@export var vert_layer_num : int = 3
@export var hor_layer_num : int = 3

@onready var layer_scene : PackedScene = preload("res://map_controller/layer/layer.tscn")

var room_list : Array[PackedScene] = [
	preload("res://maps/map_list/floor1/og_room1.tscn")
]

var reward_rooms : Array[PackedScene] = [
	preload("res://maps/map_list/floor1/reward_room1/og_rewardRoom.tscn")
]

@onready var layers : Array[Layer] = [
	
]

func _ready() -> void: 
	load_levels()
	load_rewards()

func load_levels():
	for layer_num in range(vert_layer_num):
		var new_layer : Layer = layer_scene.instantiate()
		new_layer.global_position = Vector2(0, room_size.y * (layer_num + 1))
		layers.append(new_layer)
		add_child(new_layer)
		var new_room = room_list.pick_random().instantiate()
		new_layer.add_child(new_room)
	$EndingLayer.global_position.y = (vert_layer_num + 1) * room_size.y

func load_rewards():
	for layer in layers:
		layer.spawn_reward_room(reward_rooms.pick_random())
