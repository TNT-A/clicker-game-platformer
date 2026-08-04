extends Node2D
class_name BossPhase

var total_health : float = 0.0
var max_total_health : float = 0.0

var boss_list : Array[Enemy] = []

func _ready() -> void:
	SignalBus.boss_hit.connect(set_health)
	SignalBus.enemy_killed.connect(check_death)
	start_phase()

func start_phase():
	register_bosses()
	set_max_health()
	set_health()
	print("Phase Started!!!!")

func register_bosses():
	for boss in boss_list:
		if is_instance_valid(boss):
			boss.queue_free()
	boss_list.clear()
	for child in get_children():
		if child is Enemy:
			boss_list.append(child)

func set_max_health():
	for child in boss_list:
		if is_instance_valid(child):
			max_total_health += child.max_health

func set_health():
	for child in boss_list:
		if is_instance_valid(child):
			total_health += child.health
	SignalBus.boss_health_changed.emit(total_health, max_total_health)

func check_death(enemy : Enemy):
	if boss_list.has(enemy):
		boss_list.remove_at(boss_list.find(enemy))
		set_health()
