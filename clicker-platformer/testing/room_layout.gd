extends TileMapLayer
class_name RoomLayout

@export_category("Useful Nodes")
@export var cam_marker_node : PackedScene = preload("res://room_cam/cam_marker.tscn")

@export_category("Tilesets :)")
@export var test_tileset := preload("res://maps/tileset/map_base.tres")

func _ready() -> void:
	add_to_group("nav_group")
