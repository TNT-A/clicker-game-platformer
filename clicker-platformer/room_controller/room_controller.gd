extends Node2D
class_name RoomController

@onready var room_base_scene : PackedScene = preload("res://room_controller/room_base/room_base.tscn")

#Contains info about what area the player is in, and what the designated rooms are
#Holds info about:
#Room Shape
#Room Layout
#Room Pool 
@export var area_resource : Resource

##Contains info about how many of each room type to spawn when the rooms are generated
@export_group("Room Spawn Nums")
##Number of combat rooms spawned when generate_rooms() is called
@export var num_combat_room : int = 2
##Number of special rooms spawned when generate_rooms() is called
@export var num_special_room : int = 0
##Number of boss rooms spawned when generate_rooms() is called
@export var num_boss_room : int = 0

#Has all the room pools
#region
#Holds the various combat room layouts as well as the room base associated with them
var c_room_pool : Array[PackedScene] = [
	load("res://testing/testing_room_640x_360.tscn")
]

#Holds the various special room layouts as well as the room base associated with them
var s_room_pool : Array[PackedScene] = [
	load("res://testing/testing_room_640x_360.tscn")
]

#Holds the various boss room layouts as well as the room base associated with them
var b_room_pool : Array[PackedScene] = [
	load("res://testing/testing_room_640x_360.tscn")
]

#Depracated
#var c_room_pool : Dictionary[PackedScene, PackedScene] = {
	#load("res://room_controller/test_layouts/test_room_layout_1.tscn") : load("res://testing/testing_room_640x_360.tscn"),
#}
#
#var s_room_pool : Dictionary[PackedScene, PackedScene] = {
	#load("res://room_controller/test_layouts/test_room_layout_1.tscn") : load("res://testing/testing_room_640x_360.tscn"),
#}
#
#var b_room_pool : Dictionary[PackedScene, PackedScene] = {
	#load("res://room_controller/test_layouts/test_room_layout_1.tscn") : load("res://testing/testing_room_640x_360.tscn"),
#}
#endregion

#Spawns a random room of the given type
func spawn_room(room_type : String, room_slot : int):
	if room_type == "c":
		var room_base : PackedScene
		var room_pool : Array[PackedScene] = get(room_type + "_room_pool")
		room_base = room_pool.pick_random()
		
		

#Spawns all rooms as specified in the room spawn nums grouo
func generate_rooms():
	var room_num : int = 0
	
	
	
	for i in range(num_combat_room):
		spawn_room("c", room_num)
		room_num += 1
	for i in range(num_special_room):
		spawn_room("s", room_num)
		room_num += 1
	for i in range(num_boss_room):
		spawn_room("n", room_num)
		room_num += 1
