extends Node2D
class_name PathfindingComponent

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var timer_target_reset: Timer = $TimerTargetReset

@export var active : bool = true
@export var chase_player : bool = false

@export var host_node : Node
@export var target_node : Node 
var player_node : Player

@export_category("Timer Logic") 
## Controls how long before the target position is shifted to a new pivot
@export var reset_time : float = 2.0

@export_category("Stopping Logic") 
## Controls the distance maximum before the objects stops pathfinding to it's target
@export var stop_range : float = 15.0

var host_pos : Vector2
var target_pos : Vector2
var player_pos : Vector2

func _ready() -> void:
	if InfoManager.game_manager:
		var cur_room = InfoManager.game_manager.current_room
		set_nav_layer(cur_room)
	start_timer()
	if !is_instance_valid(player_node):
		if is_instance_valid(InfoManager.player):
			player_node = InfoManager.player

func set_nav_layer(room : RoomBase):
	navigation_agent_2d.set_navigation_layer_value(room.room_slot, true)

func start_timer():
	timer_target_reset.wait_time = reset_time
	timer_target_reset.start()

func _process(delta: float) -> void:
	set_target_pos()

func set_target_pos():
	if host_node:
		host_pos = host_node.global_position
	if target_node:
		target_pos = target_node.global_position
	if player_node:
		player_pos = player_node.global_position

func make_path():
	if target_pos:
		navigation_agent_2d.target_position = target_pos

func get_path_dir():
	var next_path_pos := navigation_agent_2d.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	return dir

func change_target(target):
	if target != null:
		target_node = target
		set_target_pos()

func in_target_range() -> bool:
	var distance = global_position.distance_to(target_pos)
	if distance <= stop_range:
		return true
	else:
		return false

func _on_timer_target_reset_timeout() -> void:
	make_path()
	start_timer()

##################################################

#@export_group("Resetting Target + Choosing Pivot") 
### Controls how long before the target position is shifted to a new pivot
#@export var reset_time : float = 2.0
### Controls the pivot distance max (so the various pathfinding objects don't stack
#@export var pivot_range : float = 10.0

#@export_group("Stopping Logic") 
### Controls the distance maximum before the objects stops pathfinding to it's target
#@export var stop_range : float = 15.0

#var has_target : bool = true
#var target_pivot : Vector2 
#var target_decided : bool = false
#var at_target : bool = false

#func _ready() -> void:
	#$TimerTargetReset.wait_time = reset_time
	#$TimerTargetReset.start()
	#if chase_player == true:
		#target_node = player
	#if target_node == null:
		#has_target = false

#func _physics_process(delta: float) -> void:
	#if active:
		#pathfinding(speed)
	#if !active:
		#reset_velocity()
	#if has_target:
		#target_vector_position = target_node.global_position
	#if target_node == null:
		#has_target = false
	#if is_instance_valid(target_node):
		#new_target(target_node.global_position, pivot_range)
#
#func pathfinding(speed_change):
	#var next_path_pos := nav_agent.get_next_path_position()
	#var dir := global_position.direction_to(next_path_pos)
	#if host:
		#host.velocity = host.velocity.lerp(dir * speed_change, acceleration)
		#host.move_and_slide()

#func change_target(target):
	#if target != null:
		#target_node = target
		#target_decided = false
#
##Checks if the host is within a certain distance of their target
#func check_distance():
	#var distance = global_position.distance_to(target_vector_position)
	#if distance <= stop_range:
		#at_target = true
	#elif distance > stop_range:
		#at_target = false
#
##Pick random within range of another location [
#func random_location(location, range_D):
	#var rng = RandomNumberGenerator.new()
	#var random_position : Vector2 = Vector2()
	#random_position.x = location.x + rng.randf_range(-range_D,range_D)
	#random_position.y = location.y + rng.randf_range(-range_D,range_D)
	#return random_position
#
##Resets the pathfinding path with help of timer 
#func make_path():
	#if target_vector_position:
		#nav_agent.target_position = target_vector_position
#
##Adds a pivot distace from the actual target so that everything pathfinding to it doesn't stack
#func new_target(target_position, range_D):
	#if target_decided == false:
		#target_pivot = Vector2(0,0)
		#target_pivot = random_pivot(range_D)
		#target_decided = true
		##print(target_decided)
	#target_vector_position = target_position + target_pivot
	##print(target_vector_position, " ", target_position)
#
##resets the target_pivot value every 2 seconds
#func reset_target(range_D):
	#target_pivot = random_pivot(range_D)
#
##Pick random pivot distance from a target
#func random_pivot(range_D):
	#var rng = RandomNumberGenerator.new()
	#var random_pivot : Vector2 = Vector2()
	#random_pivot.x = rng.randf_range(-range_D,range_D)
	#random_pivot.y = rng.randf_range(-range_D,range_D)
	#return random_pivot
#
#func _on_timer_pathfinding_timeout() -> void:
	#make_path()
	#check_distance()
#
#func _on_timer_target_reset_timeout() -> void:
	#reset_target(pivot_range)
	##print("timer out")
