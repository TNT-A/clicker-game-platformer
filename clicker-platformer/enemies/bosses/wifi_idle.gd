extends State
class_name WifiBossIdle

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_timer: Timer = $"../../AttackTimer"
@onready var wifi_boss: WifiBoss = $"../.."

func enter():
	animation_player.play("wifi_idle")
	attack_timer.start()

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _on_attack_timer_timeout() -> void:
	wifi_boss.wifi_shot_1()

func _on_shot_component_shot_finished() -> void:
	attack_timer.start()
