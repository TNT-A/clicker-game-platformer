extends Node2D
class_name RoomController

@onready var room_base_scene : PackedScene = preload("res://room_controller/room_base/room_base.tscn")

#Contains info about what area the player is in, and what the designated rooms are
#Holds info about:
#Room Shape
#Room Layout
#Room Pool 
@export var area_resource : AreaResource

##Contains info about how many of each room type to spawn when the rooms are generated
@export_group("Room Spawn Nums")
##Number of combat rooms spawned when generate_rooms() is called
@export var num_combat_room : int = 1
##Number of special rooms spawned when generate_rooms() is called
@export var num_special_room : int = 0
##Number of boss rooms spawned when generate_rooms() is called
@export var num_boss_room : int = 0

#Has all the room pools
#region
var starting_room : PackedScene = load("res://testing/testing_room_640x_360.tscn")

#Holds the various combat room layouts as well as the room base associated with them
var c_room_pool : Array[PackedScene] = []

#Holds the various special room layouts as well as the room base associated with them
var s_room_pool : Array[PackedScene] = []

#Holds the various boss room layouts as well as the room base associated with them
var b_room_pool : Array[PackedScene] = []
#endregion

var room_bases : Array[RoomBase] = [
	
]

#Determines how much space to allocate to each room_base
var max_room_size : Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width") * 2, ProjectSettings.get_setting("display/window/size/viewport_height") * 2)

var floor_active : bool = false

#func _ready() -> void:
	#setup()

func setup():
	set_pools()
	generate_rooms()
	SignalBus.room_setup.connect(room_setup_complete)
	#SignalBus.swap_by_slot.connect(room_transition)
	floor_active = true

func set_pools():
	if area_resource:
		starting_room = area_resource.starting_room
		c_room_pool = area_resource.c_room_pool.get_pool()
		s_room_pool = area_resource.s_room_pool.get_pool()
		b_room_pool = area_resource.b_room_pool.get_pool()

#Returns the total number of extra rooms that will be spawned
func sum_total_rooms():
	var starting_room_num : int = 1
	return starting_room_num + num_combat_room + num_special_room + num_boss_room

#Spawns a random room of the given type. Spawns it in the room base given by the room_slot value
func spawn_room(room_type : String, room_slot : int):
	if room_type == "c":
		var room_layout : PackedScene
		var room_pool : Array[PackedScene] = get(room_type + "_room_pool")
		var room_base : RoomBase = room_bases[room_slot] 
		room_layout = room_pool.pick_random()
		var new_layout = room_layout.instantiate()
		room_base.room_type = room_type
		room_base.room_slot = room_slot + 1
		room_base.add_child(new_layout)
		room_base.set_region_size()

func spawn_starting_room():
	var room_layout : PackedScene = starting_room
	var room_base : RoomBase = room_bases[0]
	var new_layout = room_layout.instantiate()
	room_base.room_type = "start"
	room_base.room_slot =  1
	room_base.add_child(new_layout)
	room_base.set_region_size()

#Spawns a room base at the designated area
func spawn_room_base(pos_x : float, pos_y : float):
	var new_room_base : RoomBase = room_base_scene.instantiate()
	new_room_base.global_position = Vector2(pos_x, pos_y)
	room_bases.append(new_room_base)
	add_child(new_room_base)

#Spawns all of the room bases based on the number of rooms that will be spawned
func generate_room_bases():
	room_bases.clear()
	for child in get_children():
		child.queue_free()
	var grid_y : int = 0
	for i in range(sum_total_rooms()):
		spawn_room_base(0, grid_y * max_room_size.y)
		grid_y += 1

#Spawns all rooms as specified in the room spawn nums vars
func generate_rooms():
	var room_num : int = 1
	generate_room_bases()
	spawn_starting_room()
	for i in range(num_combat_room):
		spawn_room("c", room_num)
		room_num += 1
	for i in range(num_special_room):
		spawn_room("s", room_num)
		room_num += 1
	for i in range(num_boss_room):
		spawn_room("n", room_num)
		room_num += 1

#Generates the paths between each room
func generate_room_paths():
	for room in room_bases:
		if room.room_slot != sum_total_rooms():
			room.exit_paths[room.room_slot + 1] = Vector2(.5, 1)
		if room.room_slot != 1:
			room.exit_paths[room.room_slot - 1] = Vector2(.5, 0)
		if room.room_slot == sum_total_rooms(): 
			room.exit_paths["shop"] = Vector2(.5, 1)

#Triggers whenever every room has completed it's setup
func room_setup_complete(room_slot : int):
	if room_slot == sum_total_rooms():
		await generate_room_paths()
		room_bases[0].spawn_exits()
		SignalBus.floor_started.emit()
