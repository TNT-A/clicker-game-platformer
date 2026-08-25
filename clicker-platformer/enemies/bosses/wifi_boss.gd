extends Enemy
class_name WifiBoss

@onready var shot_component: ShotComponent = $ShotComponent
@onready var boss_animation_player: AnimationPlayer = $BossAnimationPlayer

var cur_index : int = 0
var initial_position : Vector2
var next_position : Vector2 = Vector2(0, 0)
var position_list : Array[Vector2] = [
	Vector2(0, 0),
	Vector2(-200, 120),
	Vector2(-200, -80),
	Vector2(200, 120),
	Vector2(200, -80),
]

func _ready() -> void:
	initial_position = InfoManager.game_manager.current_room.global_position + position

func pick_random_pos():
	var pos_list = position_list.duplicate(true)
	var selected_pos : Vector2
	var rand_index = randi_range(0, position_list.size() - 1)
	if rand_index == cur_index:
		rand_index += 1
		if rand_index > position_list.size() - 1:
			rand_index = 0
	selected_pos = initial_position + position_list[rand_index]
	cur_index = rand_index
	next_position = selected_pos
	return

func swap_to_dino():
	pass

func swap_to_wifi():
	pass

func wifi_shot_1():
	shot_component.call_pattern(Vector2(0, 0), 0)
	boss_animation_player.play("wifi_shoot")

func _on_shot_component_shot_fired() -> void:
	boss_animation_player.stop()
	boss_animation_player.play("wifi_shoot")
