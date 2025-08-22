extends Node2D

var game_manager : GameManager
var current_room : Room 
var room_pos : Vector2 = Vector2(0,0)

var enemies_to_spawn : int = 3
var select_enemy_num : int = 3
var current_enemies : Array = [
	
]

var enemy_count : int 
var active_enemies : Array = [
	
]

func _ready() -> void:
	game_manager = get_parent()
	SignalBus.room_started.connect(start_room)
	SignalBus.enemy_killed.connect(check_death)

func check_death(enemy):
	if active_enemies.has(enemy):
		active_enemies.remove_at(active_enemies.find(enemy))
		enemy_count -= 1
		#print("")
	if enemy_count <= 0:
		#print("The enemies are gone")
		SignalBus.room_ended.emit(4, current_room)

func start_room(room):
	current_room = room
	room_pos = current_room.global_position
	enemies_to_spawn = game_manager.current_enemies_to_spawn
	select_enemy_num = game_manager.currrent_select_enemy_num
	select_enemies()
	test_spawn_all()
	enemy_count = enemies_to_spawn

func select_enemies():
	current_enemies.clear()
	for num in select_enemy_num:
		var new_selection = game_manager.enemy_list_1.pick_random()
		current_enemies.append(new_selection)

func spawn_enemy(enemy:PackedScene, pos:Vector2):
	var new_enemy = enemy.instantiate()
	add_child(new_enemy)
	active_enemies.append(new_enemy)
	new_enemy.global_position = pos

func test_spawn_all():
	print("Started Spawn")
	for i in enemies_to_spawn:
		var enemy = current_enemies.pick_random()
		var rand_pos = Vector2(randi_range(110,450), randi_range(8,245)) + room_pos
		spawn_enemy(enemy, rand_pos)
