extends Node2D
class_name Layer

var reward_position : Vector2 = Vector2(580, 0)
@onready var reward_layer: Node2D = $RewardLayer

func _ready() -> void:
	reward_layer.position = reward_position

func spawn_reward_room(room : PackedScene):
	var new_room = room.instantiate()
	reward_layer.add_child(new_room)
