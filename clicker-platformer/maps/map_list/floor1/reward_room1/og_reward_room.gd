extends Room

#func _on_camera_move_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body.is_in_group("player"):
		#SignalBus.move_camera.emit($CameraPos.global_position)

var pickup_types : Array[PackedScene] = [
	#preload("res://pickups/upgrade_pickup/upgrade_pickup.tscn"),
	preload("res://pickups/reward_pickup/reward_pickup.tscn")
]

func _ready() -> void:
	spawn_pickup()

func spawn_pickup():
	var new_pickup = pickup_types.pick_random().instantiate()
	new_pickup.position = $RewardPos.position
	add_child(new_pickup)
