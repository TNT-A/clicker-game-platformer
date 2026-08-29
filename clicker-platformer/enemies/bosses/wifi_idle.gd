extends State
class_name WifiBossIdle

@onready var attack_timer: Timer = $"../../AttackTimer"
@onready var wifi_boss: WifiBoss = $"../.."
@onready var wifi_position_indicator: Sprite2D = $"../../WifiPositionIndicator"
@onready var node_animation_player: AnimationPlayer = $"../../NodeAnimationPlayer"
@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var movement_indicator: Line2D = $"../../MovementIndicator"
@onready var state_machine: StateMachine = $".."

var attacks_before_move : int = 2
var bounce_chance : float = 0.0
var to_bounce : bool = false

func enter():
	to_bounce = false
	attacks_before_move = randi_range(1, 3)
	boss_animation_player.play("wifi_idle")
	attack_timer.start()
	movement_indicator.clear_points()

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _on_attack_timer_timeout() -> void:
	pick_shot()

func pick_shot():
	var rand = randi_range(0, 2)
	if rand == 0:
		wifi_boss.wifi_shot_4()
	elif rand == 1:
		wifi_boss.wifi_shot_5()
	else:
		wifi_boss.wifi_shot_6()

func transition_to_move():
	var bounce_rand : float = randf_range(0, 1)
	if bounce_chance < bounce_rand:
		await wifi_boss.pick_random_pos()
		wifi_position_indicator.global_position = wifi_boss.next_position
		wifi_position_indicator.global_position.y -= 20
		node_animation_player.play("wifi_node_land")
		set_line()
		await get_tree().create_timer(1.5).timeout
		boss_animation_player.play("face_to_icon")
	else:
		print("me")
		await get_tree().create_timer(1.8).timeout
		boss_animation_player.play("face_to_icon")
		to_bounce = true

func set_line():
	movement_indicator.clear_points()
	movement_indicator.add_point(wifi_boss.global_position)
	movement_indicator.add_point(wifi_position_indicator.position)

func _on_shot_component_shot_finished() -> void:
	if state_machine.current_state == self:
		attacks_before_move -= 1
		if attacks_before_move <= 0:
			await get_tree().create_timer(1).timeout
			transition_to_move()
		else:
			boss_animation_player.play("wifi_idle")
			attack_timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if state_machine.current_state == self and anim_name == "face_to_icon":
		if !to_bounce:
			node_animation_player.play("wifi_node_rise")
			bounce_chance += .3
			SignalBus.transitioned.emit(self, "WifiMove")
		else:
			SignalBus.transitioned.emit(self, "WifiBounceMove")
