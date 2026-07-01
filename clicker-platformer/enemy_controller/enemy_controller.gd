extends Node2D

@onready var spawn_indicator_scene : PackedScene

@export var pool_resource : EnemyPoolResource 
var game_manager : GameManager
var current_room : Room 
var room_pos : Vector2 = Vector2(0,0)

var credits : float = 100.0
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
	SignalBus.enemy_killed.connect(check_death)
	set_pool()

func start_room(room:Room):
	current_room = room
	room_pos = current_room.global_position
	enemy_count = 0
	if room.pool_resource:
		pool_resource = room.pool_resource
		set_pool()
	init_spawn()

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

#All logic behind  spawning enemies
#region
#Chooses an enemy that is spawnable given conditions, and starts the spawning process 
func pick_spawn(array : Array[PackedScene]):
	var enemy_list = array.duplicate(true)
	if credits >= lowest_credits:
		var rng = RandomNumberGenerator.new()
		var enemy = enemy_list[rng.rand_weighted(weights.values())]
		if credit_cost[enemy] > credits:
			enemy_list.remove_at(enemy_list.find(enemy))
			pick_spawn(enemy_list)
		else:
			spawn_enemy(enemy, pick_position())
			return credit_cost[enemy]

#Rewrite later, for now it just picks fully random positions
#In the future it should be specified on a map by map basic, because we don't want enemies spawing in walls
#Could also take an enemy value parameter in case some enemies have specific spawn locations/conditions
func pick_position():
	var margin : int = 30
	return Vector2(randi_range(0 + margin, 480 - margin), randi_range(0 + margin, 270 - margin))

#Spawns an enemy and adds it to the scene as well as internal list of spawned enemies
#Also spends crdits to spawn each one
func spawn_enemy(enemy:PackedScene, pos:Vector2):
	var new_enemy = enemy.instantiate()
	active_enemies.append(new_enemy)
	enemy_count += 1
	new_enemy.global_position = pos
	add_child(new_enemy)

#Not implemented yet
func spawn_enemy_with_indicator(enemy:PackedScene, pos:Vector2):
	var new_enemy = enemy.instantiate()
	active_enemies.append(new_enemy)
	enemy_count += 1
	new_enemy.global_position = pos
	add_child(new_enemy)
	credits -= credit_cost[enemy]

#Logic for the original spawning of enemies at the start of a room
func init_spawn():
	var sub_credits = credits/4
	cred_spawn(sub_credits)

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
#endregion

func check_death(enemy):
	if active_enemies.has(enemy):
		active_enemies.remove_at(active_enemies.find(enemy))
		enemy_count -= 1
	if enemy_count <= 0 and credits < lowest_credits:
		SignalBus.room_ended.emit(3, current_room)
