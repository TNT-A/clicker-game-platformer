extends State
class_name WifiBossMove

@onready var wifi_boss: WifiBoss = $"../.."
@onready var state_machine: StateMachine = $".."
@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var movement_indicator: Line2D = $"../../MovementIndicator"

var target_pos : Vector2 = Vector2(0, 0)

func enter():
	boss_animation_player.play("spin")
	target_pos = wifi_boss.next_position

func exit():
	pass

func update(_delta: float):
	if !wifi_boss.global_position.distance_to(target_pos) <= 3:
		wifi_boss.global_position = wifi_boss.global_position.lerp(target_pos, .1)
		set_line()
	else:
		wifi_boss.global_position = wifi_boss.next_position
		swap_to_idle()

func set_line():
	movement_indicator.clear_points()
	movement_indicator.add_point(wifi_boss.global_position)
	movement_indicator.add_point(wifi_boss.next_position)

func swap_to_idle():
	boss_animation_player.play("icon_to_face")

func physics_update(_delta: float):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if state_machine.current_state == self and anim_name == "icon_to_face":
		await wifi_boss.pick_random_pos()
		SignalBus.transitioned.emit(self, "WifiIdle")
