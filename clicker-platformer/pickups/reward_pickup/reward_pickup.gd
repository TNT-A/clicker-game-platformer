extends Node2D
class_name RewardPickup

#Current Types: "Health", "Upgrade", Coin"
@export var pickup_type : String = "Health"
@export var health_num : int = 2


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		give_upgrade()

func give_upgrade():
	if pickup_type == "Health":
		SignalBus.health_pickup_get.emit(health_num)
	if pickup_type == "Upgrade":
		SignalBus.upgrade_pickup_get.emit()
	if pickup_type == "Coin":
		SignalBus.coin_pickup_get.emit()
	destroy_self()

func destroy_self():
	queue_free()
