extends Node2D
class_name BossPhase

@export var phase_name : String 
@export var phase_num : int = 0
@export var pre_phase_delay : float = 0
@export var post_phase_delay : float = 0

var total_health : float = 0.0
var max_total_health : float = 0.0

var phase_active : bool = false

var boss_list : Dictionary[Enemy, int] = {}
var boss_end_positions : Dictionary[int, Vector2] = {}

func _ready() -> void:
	SignalBus.boss_hit.connect(set_health)
	SignalBus.enemy_killed.connect(check_death)
	freeze_phase()

func register_bosses():
	for child in get_children():
		if child is Enemy:
			var new_boss : Enemy = child
			boss_list[new_boss] = new_boss.get_instance_id()
		set_phase_name()

func set_phase_name():
	var enemy_string : String = ""
	if phase_name == "":
		phase_name = "Placeholder!"

func freeze_phase():
	for child in get_children():
		if child is Enemy:
			child.process_mode = PROCESS_MODE_DISABLED
			child.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
			child.visible = false

func unfreeze_phase():
	for child in get_children():
		if child is Enemy:
			child.process_mode = Node.PROCESS_MODE_INHERIT
			child.disable_mode = CollisionObject2D.DISABLE_MODE_KEEP_ACTIVE
			child.visible = true

func start_phase():
	register_bosses()
	set_max_health()
	set_health()
	await get_tree().create_timer(pre_phase_delay).timeout
	unfreeze_phase()
	phase_active = true
	SignalBus.boss_health_changed.emit(total_health, max_total_health)
	
	print(total_health, " | ", max_total_health)

func end_phase():
	if phase_active:
		phase_active = false
		await get_tree().create_timer(post_phase_delay).timeout
		SignalBus.phase_end.emit(phase_num)

func clear_boss_list():
	for boss in boss_list.keys():
		if is_instance_valid(boss):
			boss.queue_free()
	boss_list.clear()

func set_max_health():
	max_total_health = 0
	for child in boss_list.keys():
		if is_instance_valid(child):
			max_total_health += child.max_health

func set_health():
	var new_health : float = 0.0
	for child in boss_list.keys():
		if is_instance_valid(child) and child.health >= 0:
			new_health += child.health
	total_health = new_health
	SignalBus.boss_health_changed.emit(total_health, max_total_health)
	check_phase_end()

func check_death(enemy : Enemy):
	if boss_list.has(enemy):
		boss_end_positions[enemy.get_instance_id()] = enemy.global_position
		set_health()

func check_phase_end():
	if total_health <= 0:
		end_phase()
