extends Node2D
class_name RoomBase

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D
@onready var player_check: CollisionShape2D = $Area2D/PlayerCheck
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var cam_pos: Marker2D = $CamPos

var cam_margins : Dictionary[String, float] = {
	"up" : 0, 
	"down" : 0, 
	"left" : 0, 
	"right" : 0, 
}

var room_locked : bool = false

func set_region_size():
	for child in get_children():
		if child is TileMapLayer:
			var tilemap_size : Vector2i = get_tilemap_size(child)
			var corner_pos : Vector2 = get_corner_pos(child)
			set_area_size(child)
			change_region_dimensions(tilemap_size.x, tilemap_size.y, corner_pos)
			set_cam_pos()

func get_tilemap_size(map : TileMapLayer):
	var map_rect : Rect2i = map.get_used_rect()
	var size_in_tiles : Vector2i = map_rect.size
	var tile_size : int = 16
	return size_in_tiles * tile_size

func get_corner_pos(map : TileMapLayer):
	var map_rect : Rect2i = map.get_used_rect()
	var corner_tile_coords : Vector2 = map_rect.position
	var pixel_pos : Vector2 = map.map_to_local(corner_tile_coords)
	pixel_pos.x -= 8
	pixel_pos.y -= 8
	return pixel_pos

func set_area_size(map : TileMapLayer):
	var area_rect : RectangleShape2D = RectangleShape2D.new()
	area_rect.size = get_tilemap_size(map)
	player_check.shape = area_rect
	player_check.position = Vector2(get_corner_pos(map).x + (get_tilemap_size(map).x/2), get_corner_pos(map).y + (get_tilemap_size(map).y/2))
	player_check.disabled = false

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

func set_cam_pos():
	for child in get_children():
		if child is TileMapLayer:
			for grandchild in child.get_children():
				if grandchild is CamMarker:
					cam_pos.position = grandchild.position
			set_cam_margins(child)

func set_cam_margins(map : TileMapLayer):
	var viewport_dimensions : Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	var map_dimensions : Vector2 = get_tilemap_size(map)
	var corner_pos : Vector2 = get_corner_pos(map)
	var camera_pos : Vector2 = cam_pos.position
	var total_margin_x = map_dimensions.x - viewport_dimensions.x
	var total_margin_y = map_dimensions.y - viewport_dimensions.y
	if total_margin_x < 0:
		total_margin_x = 0
	if total_margin_y < 0:
		total_margin_y = 0
	
	var expected_x = viewport_dimensions.x - InfoManager.cam_pivot.x/2
	var expected_y = viewport_dimensions.y/2
	
	var left_space = camera_pos.x - corner_pos.x
	var right_space = corner_pos.x + map_dimensions.x - camera_pos.x
	var up_space = camera_pos.y - corner_pos.y
	var down_space = corner_pos.y + map_dimensions.y - camera_pos.y
	
	if total_margin_x > 0:
		cam_margins["left"] = left_space - expected_x
		cam_margins["right"] = right_space - expected_x
	if total_margin_y > 0:
		cam_margins["up"] = up_space - expected_y
		cam_margins["down"] = down_space - expected_y
	
	print(cam_margins)
	if cam_margins["left"] < 0:
		#cam_pos.position.x -= cam_margins["left"]
		cam_margins["right"] -= cam_margins["left"]
		cam_margins["left"] = 0
	if cam_margins["right"] < 0:
		#cam_pos.position.x += cam_margins["left"]
		cam_margins["left"] -= cam_margins["right"]
		cam_margins["right"] = 0
	if cam_margins["up"] < 0:
		#cam_pos.position.y -= cam_margins["up"]
		cam_margins["down"] -= cam_margins["up"]
		cam_margins["up"] = 0
	if cam_margins["down"] < 0:
		#cam_pos.position.y += cam_margins["down"]
		cam_margins["up"] -= cam_margins["down"]
		cam_margins["down"] = 0
	print(cam_margins)

func transition_cam():
	SignalBus.move_camera.emit(cam_pos.global_position, cam_margins)

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		if !room_locked:
			transition_cam()
