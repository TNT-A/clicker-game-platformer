extends Node2D
class_name RoomBase

@onready var room_transitioner_scene : PackedScene = preload("res://room_controller/room_transitions/room_transitioner.tscn")

@onready var invis_walls: StaticBody2D = $InvisWalls
@onready var left: CollisionShape2D = $InvisWalls/Left
@onready var right: CollisionShape2D = $InvisWalls/Right
@onready var up: CollisionShape2D = $InvisWalls/Up
@onready var down: CollisionShape2D = $InvisWalls/Down

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

@export var enemy_pool : EnemyPoolResource
@export var room_slot : int = 1
@export var to_room_slot : int = 1

#Should be [int/string, Vector2] ~ [room slot/specialty, direction]
var exit_paths : Dictionary = {
	
}

#Not implemented
var extra_exit_paths : Dictionary = {
	
}

#Not implemented
var clear_rewards : Array[PackedScene] = [
	
]

var tilemap_ref : TileMapLayer

var room_started : bool = false
var room_locked : bool = false
var in_room : bool = false
var setup_complete : bool = false

var room_type : String = "c"
var room_pos : Vector2 

func _ready() -> void:
	SignalBus.room_ended.connect(end_room)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and in_room and !room_started:
		start_room()

func start_room():
	room_started = true
	if room_type == "c":
		room_locked = true
		SignalBus.room_started.emit(self)
	if room_type == "b":
		room_locked = true
		SignalBus.boss_room_started.emit(self)

func end_room(finished_room_slot : int, room : RoomBase):
	#print("Room ended: " + str(self))
	if room == self:
		spawn_exits()
		spawn_clear_rewards()

func spawn_exits():
	for exit_slot in exit_paths.keys():
		var new_transitioner : RoomTransitioner = room_transitioner_scene.instantiate()
		var transitioner_pos : Vector2 = get_cardinal_pos(exit_paths[exit_slot])
		new_transitioner.cur_room_slot = room_slot
		new_transitioner.to_room_slot = exit_slot
		if str(exit_slot) == "shop":
			new_transitioner.move_to_shop = true
		await call_deferred("add_child", new_transitioner)
		new_transitioner.position = transitioner_pos

func spawn_clear_rewards():
	for clear_reward in clear_rewards:
		var new_reward = clear_reward.instantiate()
		new_reward.position = get_random_pos() - self.position
		add_child(new_reward)

func spawn_walls(map : TileMapLayer):
	var map_dimensions : Vector2 = get_tilemap_size(map)
	var l_wall_shape : RectangleShape2D = RectangleShape2D.new()
	var r_wall_shape : RectangleShape2D = RectangleShape2D.new()
	var u_wall_shape : RectangleShape2D = RectangleShape2D.new()
	var d_wall_shape : RectangleShape2D = RectangleShape2D.new()
	l_wall_shape.size = Vector2(2, map_dimensions.y)
	r_wall_shape.size = Vector2(2, map_dimensions.y)
	u_wall_shape.size = Vector2(map_dimensions.x, 2)
	d_wall_shape.size = Vector2(map_dimensions.x, 2)
	left.shape = l_wall_shape
	right.shape = r_wall_shape
	up.shape = u_wall_shape
	down.shape = d_wall_shape
	left.position = Vector2(get_corner_pos(map).x, get_corner_pos(map).y + map_dimensions.y/2)
	right.position = Vector2(get_corner_pos(map).x + map_dimensions.x, get_corner_pos(map).y + map_dimensions.y/2)
	up.position = Vector2(get_corner_pos(map).x + map_dimensions.x/2, get_corner_pos(map).y)
	down.position = Vector2(get_corner_pos(map).x + map_dimensions.x/2, get_corner_pos(map).y + map_dimensions.y)

func set_region_size():
	for child in get_children():
		if child is TileMapLayer:
			tilemap_ref = child
			var tilemap_size : Vector2i = get_tilemap_size(child)
			var corner_pos : Vector2 = get_corner_pos(child)
			spawn_walls(child)
			set_area_size(child)
			change_region_dimensions(tilemap_size.x, tilemap_size.y, corner_pos)
			set_cam_pos()
			await set_player_spawn_pos()
			SignalBus.room_setup.emit(room_slot)

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

func get_random_pos() -> Vector2:
	var rand_pos = NavigationServer2D.map_get_random_point(
			navigation_region_2d.get_navigation_map(),
			navigation_region_2d.navigation_layers,
			false
		)
	return rand_pos

func get_cardinal_pos(dir : Vector2):
	var pos : Vector2 = Vector2(0, 0)
	var map_dimensions = get_tilemap_size(tilemap_ref)
	var margin : int = 60
	pos = get_corner_pos(tilemap_ref)
	pos.x += dir.x * map_dimensions.x
	pos.y += dir.y * map_dimensions.y
	if dir.x > 0.5:
		pos.x -= margin
	if dir.x < 0.5:
		pos.x += margin
	if dir.y > 0.5:
		pos.y -= margin
	if dir.y < 0.5:
		pos.y += margin
	return pos

func set_area_size(map : TileMapLayer):
	var area_rect : RectangleShape2D = RectangleShape2D.new()
	area_rect.size = get_tilemap_size(map)
	player_check.shape = area_rect
	player_check.position = Vector2(get_corner_pos(map).x + (get_tilemap_size(map).x/2), get_corner_pos(map).y + (get_tilemap_size(map).y/2))
	player_check.disabled = false

func change_region_dimensions(width : float, height : float, pos : Vector2):
	var nav_poly : NavigationPolygon = navigation_region_2d.navigation_polygon
	var layout : NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()
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
	layout.add_obstruction_outline(new_vertices)
	#nav_poly.make_polygons_from_outlines()
	NavigationServer2D.parse_source_geometry_data(nav_poly, layout, self)
	#NavigationServer2D.bake_from_source_geometry_data()
	navigation_region_2d.navigation_polygon = nav_poly
	navigation_region_2d.navigation_polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	navigation_region_2d.navigation_polygon.source_geometry_group_name = "nav_group"
	navigation_region_2d.navigation_polygon.agent_radius = 8
	navigation_region_2d.set_navigation_layer_value(room_slot, true)
	navigation_region_2d.bake_navigation_polygon()

func set_cam_pos():
	for child in get_children():
		if child is TileMapLayer:
			for grandchild in child.get_children():
				if grandchild is CamMarker:
					cam_pos.position = grandchild.position
			set_cam_margins(child)

func set_player_spawn_pos():
	var max_attempts : int = 30
	var attempts : int = 0
	while attempts < max_attempts:
		await get_tree().physics_frame
		attempts += 1
		var test_point = get_random_pos()
		if test_point != Vector2.ZERO:
			player_spawn.global_position = test_point
			#print("Navigation ready after ", attempts, " frames / Spawn Point: " + str(player_spawn.position))
			return
		if attempts == max_attempts:
			print("Why????: " + test_point)

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
	
	#print(cam_margins)
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
	#print(cam_margins)

func transition_cam():
	SignalBus.move_camera.emit(cam_pos.global_position, cam_margins)

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		if !room_started:
			in_room = true
			#start_room()
		#if !room_locked:
		transition_cam()
