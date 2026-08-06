extends Resource
class_name AreaResource

@export var area_name : String = "Testing"
@export var area_enemy_pool : EnemyPoolResource
@export var area_boss_pool : Array[BossEvent]
@export var area_background : PackedScene = preload("res://background/bg.tscn")

##Represents how many floors an area will have in it's default state
@export var base_floor_nums : int = 3
##Represents the base size of a floor
@export var base_floor_size : int = 5

#@export_group("Room Pools")
@export var starting_room : PackedScene = preload("res://testing/testing_room_640x_360.tscn")
##Combat Room Pool
@export var c_room_pool : RoomPoolResource 
##Special Room Pool
@export var s_room_pool : RoomPoolResource
##Boss Room Pool
@export var b_room_pool : RoomPoolResource
