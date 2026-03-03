extends Node2D
@export var ability_resource : Resource

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		pop_up_ability()

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		pop_out_ability()

func pop_up_ability():
	#$Panel.visible = true
	pass

func pop_out_ability():
	#$Panel.visible = false
	pass

func pickup_ability():
	pass
