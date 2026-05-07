extends Node2D
class_name AbilityPickup
@export var ability_resource : AbilityResource

@onready var label_ability: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/LabelAbility
@onready var label_desc: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Stats/VBoxContainer/LabelDesc
@onready var label_stats: Label = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Stats/VBoxContainer/LabelStats
@onready var icon: TextureRect = $CanvasLayer/Display/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Icon
@onready var display: PanelContainer = $CanvasLayer/Display
@onready var pickup_sprite: Sprite2D = $PickupSprite

@onready var draggable : Draggable = $Draggable
@onready var draggable_shape: CollisionShape2D = $Draggable/CollisionShape2D

var hovered : bool = false
@export var active : bool = true

func _ready() -> void:
	SignalBus.ability_pickup_popup.connect(pop_out_ability)
	SignalBus.drag_used.connect(used_up)
	display.visible = false
	set_resource()
	set_display()

func _physics_process(delta: float) -> void:
	pass

#Code for hovering and info popup
#region
func pop_up_ability():
	check_active()
	SignalBus.ability_pickup_popup.emit()
	display.visible = true
	display.global_position = global_position
	display.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(display, "global_position", Vector2(240 - display.size.x/2, 135 - display.size.y/2), 0.2)
	tween.parallel().tween_property(display, "scale", Vector2(1,1), 0.2)

func pop_out_ability():
	check_active()
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(display, "global_position", global_position, 0.2)
	tween.parallel().tween_property(display, "scale", Vector2(0, 0), 0.2)

func check_active():
	if active:
		draggable_shape.disabled = false
	else:
		draggable_shape.disabled = true

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
		ability_resource.set_rarity()
		label_ability.text = " " + str(ability_resource.ability_name) + " "
		label_desc.text = ability_resource.description
		label_stats.text = " Damage: " + str(ability_resource.ability_damage) + "\n" + " Clicks: " + str(ability_resource.ability_max)
		icon.texture = ability_resource.icon
		if ability_resource.rarity == 0:
			pickup_sprite.modulate = AbilityResource.rarity_common_color
			display.modulate = AbilityResource.rarity_common_color
		if ability_resource.rarity == 1:
			pickup_sprite.modulate = AbilityResource.rarity_uncommon_color
			display.modulate = AbilityResource.rarity_uncommon_color
		if ability_resource.rarity == 2:
			pickup_sprite.modulate = AbilityResource.rarity_rare_color
			display.modulate = AbilityResource.rarity_rare_color
		if ability_resource.rarity == 3:
			pickup_sprite.modulate = AbilityResource.rarity_epic_color
			display.modulate = AbilityResource.rarity_epic_color
		if ability_resource.rarity == 4:
			pickup_sprite.modulate = AbilityResource.rarity_legendary_color
			display.modulate = AbilityResource.rarity_legendary_color

#endregion

#Code for generating or manipulating the ability resource
#region
func set_resource():
	if !ability_resource:
		generate_resource()
	draggable.info = ability_resource

#Generates a random resource
func generate_resource():
	var base_ability_num : int = randi_range(1, AbilityResource.total_ability_count)
	var new_resource : AbilityResource = load("res://clicker_panel/resources/resource_folder/ability" + str(base_ability_num) + ".tres").duplicate()
	var rarity_roll : int = randi_range(1, 12)
	if rarity_roll == 12:
		new_resource.rarity = 4
	elif rarity_roll >= 11:
		new_resource.rarity = 3
	elif rarity_roll >= 9:
		new_resource.rarity = 2
	elif rarity_roll >= 6:
		new_resource.rarity = 1
	else:
		new_resource.rarity = 0
	ability_resource = new_resource

#endregion

#Code for removing pickups
#region
func used_up(used_draggable : Draggable):
	print("Okey ",  used_draggable, " and ", draggable)
	if draggable == used_draggable:
		queue_free()
#endregion
