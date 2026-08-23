extends Resource
class_name RoomPoolResource

enum RoomList {
	TESTROOMS_C_1,
	TESTROOMS_B_1,
	MACONDO_SHIP1_R1,
	MACONDO_SHIP1_R2,
	MACONDO_SHIP1_R3,
	MACONDO_SHIP1_R4,
	MACONDO_SHIP1_R5,
	MACONDO_SHIP1_R6,
	MACONDO_SHIP1_R7,
	MACONDO_SHIP1_R8,
	MACONDO_SHIP1_R9,
	MACONDO_SHIP1_R10,
}

var enemy_list_info : Dictionary[RoomList, PackedScene] = {
	RoomList.TESTROOMS_C_1 : preload("res://testing/testing_room_640x_360.tscn"),
	RoomList.TESTROOMS_B_1 : preload("res://room_controller/test_layouts/test_boss_room.tscn"),
	RoomList.MACONDO_SHIP1_R1 : preload("res://room_controller/test_layouts/ms1_r1.tscn"),
	RoomList.MACONDO_SHIP1_R2 : preload("res://room_controller/test_layouts/ms1_r2.tscn"),
	RoomList.MACONDO_SHIP1_R3 : preload("res://room_controller/test_layouts/ms1_r3.tscn"),
	RoomList.MACONDO_SHIP1_R4 : preload("res://room_controller/test_layouts/ms1_r4.tscn"),
	RoomList.MACONDO_SHIP1_R5 : preload("res://room_controller/test_layouts/ms1_r5.tscn"),
	RoomList.MACONDO_SHIP1_R6 : preload("res://room_controller/test_layouts/ms1_r6.tscn"),
	RoomList.MACONDO_SHIP1_R7 : preload("res://room_controller/test_layouts/ms1_r7.tscn"),
	RoomList.MACONDO_SHIP1_R8 : preload("res://room_controller/test_layouts/ms1_r8.tscn"),
	RoomList.MACONDO_SHIP1_R9 : preload("res://room_controller/test_layouts/ms1_r9.tscn"),
	RoomList.MACONDO_SHIP1_R10 : preload("res://room_controller/test_layouts/ms1_r10.tscn"),
}

@export var room_pool : Array[RoomList] = [
	
]

func get_pool():
	var room_list : Array[PackedScene]
	for room in room_pool:
		room_list.append(enemy_list_info[room])
	return room_list
