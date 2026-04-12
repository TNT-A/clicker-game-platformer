extends Node2D
class_name AbilityPickup
@export var ability_resource : AbilityResource

var hovered : bool = false

func _ready() -> void:
	SignalBus.ability_pickup_popup.connect(pop_out_ability)
	$Display.visible = false

func _physics_process(delta: float) -> void:
	pass
	#if hovered and Input.is_action_pressed("Click"):
		#global_position = get_global_mouse_position() - Vector2(10, 10)

#Code for hovering, dragging, and info popup
#region
func pop_up_ability():
	SignalBus.ability_pickup_popup.emit()
	$Display.visible = true
	$Display.position = Vector2(0,0)
	$Display.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($Display, "position", Vector2(0 - $Display.custom_minimum_size.x/2 - 6, -80), 0.2)
	tween.parallel().tween_property($Display, "scale", Vector2(1,1), 0.2)

func pop_out_ability():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($Display, "position", Vector2(0, 0), 0.2)
	tween.parallel().tween_property($Display, "scale", Vector2(0, 0), 0.2)

func pickup_ability():
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		hovered = true
		pop_up_ability()

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		hovered = false
		pop_out_ability()

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	pop_up_ability()

func _on_area_2d_mouse_exited() -> void:
	hovered = false
	pop_out_ability()
#endregion
