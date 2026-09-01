#Still needs some heavy tweaks. Rn there is a bug where if you kill a boss, 
#the back health bar will take a second to update and thus not exist for a 
#bit before randomly spawning in. I think this could be fixed if I used a dedicated
#function and process for setting the health bar values instead of tweens and tree 
#timers, but that may be even more jank so work on that later. Actually found a
#psuedo fix for this by adding a delay between phases, but should probably still 
#tackle the issue at the source at some point

extends Control
class_name BossUI

@onready var center_container: CenterContainer = $CenterContainer
@onready var boss_label: Label = $CenterContainer/VBoxContainer/BossLabel

@onready var back_boss_bar: ProgressBar = $CenterContainer/VBoxContainer/BackBossBar
@onready var top_boss_bar: ProgressBar = $CenterContainer/VBoxContainer/BackBossBar/TopBossBar

var cur_phase : BossPhase
var cur_tween : Tween

func _ready() -> void:
	SignalBus.boss_health_changed.connect(update_ui)
	SignalBus.phase_end.connect(end_phase)
	pop_down_ui()

func start_boss(phase : BossPhase):
	cur_phase = phase
	set_ui()
	pop_up_ui()
	update_ui(cur_phase.total_health, cur_phase.max_total_health)

func end_boss():
	pop_down_ui()

func pop_up_ui():
	center_container.visible = true

func pop_down_ui():
	center_container.visible = false

func set_ui():
	if cur_tween:
		cur_tween.kill()
		cur_tween = null
	if is_instance_valid(cur_phase):
		boss_label.text = cur_phase.phase_name
		top_boss_bar.value = cur_phase.total_health
		top_boss_bar.max_value = cur_phase.max_total_health
		back_boss_bar.value = cur_phase.total_health
		back_boss_bar.max_value = cur_phase.max_total_health

func update_ui(total_health : float, max_total_health : float):
	#print("boss hit: " + str(total_health))
	if is_instance_valid(cur_phase):
		top_boss_bar.value = cur_phase.total_health
		var tween = get_tree().create_tween()
		#tween.parallel().tween_property(top_boss_bar, "value", cur_phase.total_health, .1)
		tween.parallel().tween_property(back_boss_bar, "value", cur_phase.total_health, .6)
		tween.pause()
		await get_tree().create_timer(.6).timeout
		if tween:
			tween.play()
		cur_tween = tween

func end_phase(phase_num):
	#print("Set zero called!")
	if cur_tween:
		cur_tween.kill()
		cur_tween = null
	top_boss_bar.value = 0
	#back_boss_bar.value = 0
