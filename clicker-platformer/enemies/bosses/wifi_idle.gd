extends State
class_name WifiBossIdle

@onready var attack_timer: Timer = $"../../AttackTimer"
@onready var wifi_boss: WifiBoss = $"../.."
@onready var wifi_position_indicator: Sprite2D = $"../../WifiPositionIndicator"
@onready var node_animation_player: AnimationPlayer = $"../../NodeAnimationPlayer"
@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var movement_indicator: Line2D = $"../../MovementIndicator"

var attacks_before_move : int = 2

func enter():
	attacks_before_move = randi_range(1, 3)
	boss_animation_player.play("wifi_idle")
	attack_timer.start()

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _on_attack_timer_timeout() -> void:
	wifi_boss.wifi_shot_1()

func transition_to_move():
	await wifi_boss.pick_random_pos()
	wifi_position_indicator.global_position = wifi_boss.next_position
	wifi_position_indicator.global_position.y -= 20
	node_animation_player.play("wifi_node_land")
	set_line()
	await get_tree().create_timer(2).timeout
	boss_animation_player.play("face_to_icon")

func set_line():
	#movement_indicator.clear_points()
	#movement_indicator.add_point(wifi_position_indicator.position)
	#movement_indicator.add_point(wifi_boss.next_position)
	pass

func _on_shot_component_shot_finished() -> void:
	attacks_before_move -= 1
	if attacks_before_move <= 0:
		transition_to_move()
	else:
		boss_animation_player.play("wifi_idle")
		attack_timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "face_to_icon":
		node_animation_player.play("wifi_node_rise")
		SignalBus.transitioned.emit(self, "WifiMove")
