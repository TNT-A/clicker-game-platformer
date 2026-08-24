extends Enemy
class_name WifiBoss

@onready var shot_component: ShotComponent = $ShotComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func swap_to_dino():
	pass

func swap_to_wifi():
	pass

func wifi_shot_1():
	shot_component.call_pattern(Vector2(0, 0), 0)
	animation_player.play("wifi_shoot")

func _on_shot_component_shot_fired() -> void:
	animation_player.stop()
	animation_player.play("wifi_shoot")
