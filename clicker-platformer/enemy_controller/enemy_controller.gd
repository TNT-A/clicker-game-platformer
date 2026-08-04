extends Node2D

@onready var spawn_indicator_scene : PackedScene = preload("res://enemies/spawn_indicator/spawn_indicator.tscn")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var boss_ui: BossUI = $CanvasLayer/BossUI

@export var area_resource : AreaResource
@export var pool_resource : EnemyPoolResource 

var game_manager : GameManager
var current_room : RoomBase
var room_pos : Vector2 = Vector2(0,0)

var room_active : bool = false

var template_credits : float = 25.0
var base_credits : float = 25.0
var credits : float = 0.0
var enemy_count : int 

var active_enemies : Array = [
	
]

#Parallel arrays that represent all of the enemies, spawn weights, 
#and credit costs from a resource
var enemies : Array[PackedScene] = []
var weights : Dictionary[PackedScene, float] = {}
var credit_cost : Dictionary[PackedScene, float] = {}
var lowest_credits : float = 0.0

func _ready() -> void:
	game_manager = get_parent()
	SignalBus.room_started.connect(start_room)
	SignalBus.boss_room_started.connect(start_boss_room)
	SignalBus.enemy_spawned.connect(register_enemy)
	SignalBus.enemy_killed.connect(check_death)

func setup():
	if area_resource:
		pool_resource = area_resource.area_enemy_pool
	else:
		print("???")
	set_pool()

func start_room(room:RoomBase):
	print("Room Started")
	base_credits = template_credits * (1.0 + (InfoManager.current_floor_num / 10))
	expected_enemy_num = 4 + InfoManager.current_floor_num
	current_room = room
	enemy_count = 0
	credits = base_credits
	
	if area_resource:
		pool_resource = area_resource.area_enemy_pool
	
	set_pool()
	init_spawn()
	room_active = true

#Sets the enemy pools and related values based on the resource applied
func set_pool():
	enemies.clear()
	weights.clear()
	credit_cost.clear()
	lowest_credits = 999999
	for enemy in pool_resource.pool.keys():
		enemies.append(pool_resource.enemy_list_info[enemy])
		weights[pool_resource.enemy_list_info[enemy]] = pool_resource.pool[enemy].spawn_weight
		credit_cost[pool_resource.enemy_list_info[enemy]] = pool_resource.pool[enemy].credit_num
	for cost in credit_cost.values():
		#print(credit_cost.values())
		if cost <= lowest_credits:
			lowest_credits = cost

#All logic behind spawning enemies
#region
#Chooses an enemy that is spawnable given conditions, and starts the spawning process 
#Could be rewritten at some point, the commented out part helps make sure it doesn't 
#rerun indefinitely, but it breaks due to another part of the code
func pick_spawn(array : Array[PackedScene]):
	var enemy_list = array.duplicate(true)
	if credits >= lowest_credits:
		var rng = RandomNumberGenerator.new()
		var enemy = enemy_list[rng.rand_weighted(weights.values())]
		if credit_cost[enemy] > credits:
			#enemy_list.remove_at(enemy_list.find(enemy))
			pick_spawn(enemy_list)
		else:
			spawn_enemy_with_indicator(enemy, pick_position(), false)
			return credit_cost[enemy]

#Rewrite later, for now it just picks fully random positions
#In the future it should be specified on a map by map basic, because we don't want enemies spawing in walls
#Could also take an enemy value parameter in case some enemies have specific spawn locations/conditions
func pick_position():
	var pos
	if current_room:
		pos = NavigationServer2D.map_get_random_point(current_room.navigation_region_2d.get_navigation_map(), current_room.navigation_region_2d.navigation_layers, false)
		print(pos)
	else:
		var margin : int = 70
		pos = room_pos + Vector2(randi_range(0 + margin, 480 - margin), randi_range(0 + margin, 270 - margin))
	return pos

#Spawns an enemy and adds it to the scene as well as internal list of spawned enemies
#Also spends credits to spawn each one
func spawn_enemy(enemy:PackedScene, pos:Vector2, is_boss : bool):
	var new_enemy = enemy.instantiate()
	if !is_boss:
		active_enemies.append(new_enemy)
		enemy_count += 1
	new_enemy.global_position = pos
	call_deferred("add_child", new_enemy)

#Spawns an enemy via a spawn indicator, letting the player know where they'll appear
func spawn_enemy_with_indicator(enemy:PackedScene, pos:Vector2, is_boss : bool):
	var enemy_indicator : SpawnIndicator = spawn_indicator_scene.instantiate()
	enemy_indicator.global_position = pos
	enemy_indicator.spawn_pos = pos
	enemy_indicator.enemy_to_spawn = enemy
	enemy_indicator.is_boss = is_boss
	add_child(enemy_indicator)
	credits -= credit_cost[enemy]

#Adds the spawned enemy to the active_enemies list and increaes enemy_count
func register_enemy(enemy:Enemy, is_boss:bool):
	if !is_boss:
		active_enemies.append(enemy)
		enemy_count += 1
	if is_boss:
		boss_ui.add_boss(enemy)
		boss_ui.start_boss()

#Logic for the original spawning of enemies at the start of a room
func init_spawn():
	var sub_credits = credits/4
	cred_spawn(sub_credits)
	reset_timer()

#Spawns 1 enemy based on weights and credits
func solo_spawn():
	var pot_cred = pick_spawn(enemies)
	if pot_cred is float:
		credits -= pot_cred

#Spawns 1 enemy based on weights and credits, but spawns it for free
func free_spawn():
	pick_spawn(enemies)

#Spawns a given # of enemies
func multi_spawn(num : int):
	for i in range(num):
		solo_spawn()

#Spawns enemies based on a given # of credits
func cred_spawn(sub_credits : float):
	var cred : float = sub_credits
	while cred > lowest_credits:
		var pot_cred = pick_spawn(enemies)
		if pot_cred is float:
			cred -= pot_cred
	credits -= sub_credits

var expected_enemy_num : int = 5
var base_spawn_time : float = 6.0
var spawn_time_margin : float = 1.0
func reset_timer():
	spawn_timer.wait_time = randf_range(base_spawn_time - spawn_time_margin, base_spawn_time + spawn_time_margin)
	spawn_timer.start()

func analyze_spawn():
	var state_offset = enemy_count - expected_enemy_num 
	if enemy_count <= expected_enemy_num/3:
		solo_spawn()
	elif state_offset <= 0:
		var rand = randi_range(0, 2)
		if rand == 0:
			var num_spawn = randi_range(1, 1 + (state_offset/2))
			multi_spawn(num_spawn)
		elif rand == 1:
			solo_spawn()
	elif state_offset > 0:
		var rand = randi_range(0, 100)
		var spawn_chance = 50 * (1.0 + (state_offset/10))
		if rand > spawn_chance:
			solo_spawn()

func _on_spawn_timer_timeout() -> void:
	analyze_spawn()
	reset_timer()

func start_boss_room(room:RoomBase):
	current_room = room
	enemy_count = 0
	set_pool()
	if area_resource:
		pool_resource = area_resource.area_boss_pool
	start_boss()
	room_active = true

func start_boss():
	var chosen_boss : PackedScene = enemies.pick_random()
	spawn_enemy_with_indicator(chosen_boss, current_room.get_random_pos(), true)
	#!!!!! KEEP WORKING ON THIS !!!!

#endregion

func check_death(enemy):
	if active_enemies.has(enemy):
		active_enemies.remove_at(active_enemies.find(enemy))
		enemy_count -= 1
	if enemy_count <= 0 and credits < lowest_credits:
		var no_indicators : bool = true
		for child in self.get_children():
			if child is SpawnIndicator:
				no_indicators = false
		if no_indicators and room_active:
			room_active = false
			SignalBus.room_ended.emit(current_room.room_slot, current_room)
			print("Room ended signal emitted")
	else:
		analyze_spawn()
		#reset_timer()
