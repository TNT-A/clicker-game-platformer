extends Control
class_name BossUI

@onready var center_container: CenterContainer = $CenterContainer
@onready var boss_label: Label = $CenterContainer/VBoxContainer/BossLabel
@onready var top_boss_bar: ProgressBar = $CenterContainer/VBoxContainer/TopBossBar
@onready var back_boss_bar: ProgressBar = $CenterContainer/VBoxContainer/TopBossBar/BackBossBar

var current_bosses : Array[Enemy] = [] 

func _ready() -> void:
	SignalBus.boss_hit.connect(update_ui)
	SignalBus.enemy_killed.connect(check_end)
	pop_down_ui()

func add_boss(boss : Enemy):
	current_bosses.append(boss)

func start_boss():
	set_ui()
	pop_up_ui()

func end_boss():
	pop_down_ui()

func pop_up_ui():
	center_container.visible = true

func pop_down_ui():
	center_container.visible = false

func set_ui():
	var total_health : float = 0
	var total_max_health : float = 0
	for cur_boss in current_bosses:
		total_health += cur_boss.health
		total_max_health += cur_boss.max_health
	top_boss_bar.value = total_health
	top_boss_bar.max_value = total_max_health

func update_ui(boss : Enemy):
	var total_health : float = 0
	for cur_boss in current_bosses:
		total_health += cur_boss.health
	top_boss_bar.value = total_health

func check_end(boss : Enemy):
	if boss.is_boss:
		if top_boss_bar.value == 0:
			pop_down_ui()
