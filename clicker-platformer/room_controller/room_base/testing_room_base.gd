extends Node2D

@onready var room_base: RoomBase = $RoomBase

func _ready() -> void:
	room_base.set_region_size()
	pass
