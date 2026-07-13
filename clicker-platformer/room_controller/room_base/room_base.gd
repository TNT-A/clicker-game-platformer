extends Node2D
class_name RoomBase

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D

func _ready() -> void:
	set_region_size()

func set_region_size():
	for child in get_children():
		if child is TileMapLayer:
			var tilemap_size : Vector2i = get_tilemap_size(child)
			var corner_pos : Vector2 = get_corner_pos(child)
			change_region_dimensions(tilemap_size.x, tilemap_size.y, corner_pos)

func get_tilemap_size(map : TileMapLayer):
	var map_rect : Rect2i = map.get_used_rect()
	var size_in_tiles : Vector2i = map_rect.size
	var tile_size : int = 16
	return size_in_tiles * tile_size

func get_corner_pos(map : TileMapLayer):
	var map_rect : Rect2i = map.get_used_rect()
	var corner_tile_coords : Vector2 = map_rect.position
	var pixel_pos : Vector2 = to_global(map.map_to_local(corner_tile_coords))
	pixel_pos.x -= 8
	pixel_pos.y -= 8
	return pixel_pos

func change_region_dimensions(width : float, height : float, pos : Vector2):
	var nav_poly : NavigationPolygon = navigation_region_2d.navigation_polygon
	if !nav_poly:
		nav_poly = NavigationPolygon.new()
	nav_poly.clear()
	var new_vertices = PackedVector2Array([
		Vector2(pos.x, pos.y),
		Vector2(pos.x + width, pos.y),
		Vector2(pos.x + width, pos.y + height),
		Vector2(pos.x, pos.y + height),
	])
	nav_poly.add_outline(new_vertices)
	nav_poly.make_polygons_from_outlines()
	navigation_region_2d.navigation_polygon = nav_poly
	navigation_region_2d.navigation_polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	navigation_region_2d.navigation_polygon.source_geometry_group_name = "nav_group"
	navigation_region_2d.navigation_polygon.agent_radius = 8
	navigation_region_2d.bake_navigation_polygon()
