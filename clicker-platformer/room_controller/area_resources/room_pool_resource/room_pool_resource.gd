extends Resource
class_name RoomPoolResource

enum RoomList {
	TESTROOMS_C_1,
}

var enemy_list_info : Dictionary[RoomList, PackedScene] = {
	RoomList.TESTROOMS_C_1 : preload("res://testing/testing_room_640x_360.tscn"),
}

@export var room_pool : Array[RoomList] = [
	
]

func get_pool():
	var room_list : Array[PackedScene]
	for room in room_pool:
		room_list.append(enemy_list_info[room])
	return room_list
