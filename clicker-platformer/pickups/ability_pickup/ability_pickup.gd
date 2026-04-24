extends Node2D
class_name AbilityPickup
@export var ability_resource : AbilityResource


@onready var label_ability: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/LabelAbility
@onready var label_desc: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Stats/VBoxContainer/LabelDesc
@onready var label_stats: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Stats/VBoxContainer/LabelStats
@onready var icon: TextureRect = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Icon
@onready var display: PanelContainer = $CanvasLayer/Display

@onready var draggable : Draggable = $Draggable

var hovered : bool = false

func _ready() -> void:
	SignalBus.ability_pickup_popup.connect(pop_out_ability)
	display.visible = false
	set_display()
	set_resource()

func _physics_process(delta: float) -> void:
	pass

#Code for hovering and info popup
#region
func pop_up_ability():
	SignalBus.ability_pickup_popup.emit()
	display.visible = true
	display.global_position = global_position
	display.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(display, "global_position", Vector2(240 - display.size.x/2, 135 - display.size.y/2), 0.2)
	tween.parallel().tween_property(display, "scale", Vector2(1,1), 0.2)

func pop_out_ability():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(display, "global_position", global_position, 0.2)
	tween.parallel().tween_property(display, "scale", Vector2(0, 0), 0.2)

#func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body.is_in_group("player"):
		#hovered = true
		#pop_up_ability()
#
#func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body.is_in_group("player"):
		#hovered = false
		#pop_out_ability()

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	pop_up_ability()

func _on_area_2d_mouse_exited() -> void:
	hovered = false
	pop_out_ability()
#endregion

#Code for setting up the display panel
#region
func set_display():
	if ability_resource:
		label_ability.text = " " + str(ability_resource.ability_name) + " "
		label_desc.text = ability_resource.description
		label_stats.text = " Damage: " + str(ability_resource.ability_damage) + "\n" + " Clicks: " + str(ability_resource.ability_max)
		icon.texture = ability_resource.icon

#endregion

#Code for generating or manipulating the ability resource
#region
func set_resource():
	if ability_resource:
		draggable.info = ability_resource
	else:
		generate_resource()

func generate_resource():
	pass

#endregion
