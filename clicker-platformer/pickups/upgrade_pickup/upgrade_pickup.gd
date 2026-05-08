extends Node2D
class_name UpgradePickup

#Doesn't work outside of shop!

@onready var type_sprite: Sprite2D = $BaseSprite/TypeSprite
@onready var draggable: Draggable = $Draggable
@onready var draggable_shape: CollisionShape2D = $Draggable/CollisionShape2D

@export var upgrade_type : String = ""
@export var active : bool = true

func _ready() -> void:
	SignalBus.drag_used.connect(used_up)
	set_draggable()
	if upgrade_type == "":
		assign_upgrade()
	type_sprite.texture = load("res://sprites/pickups/" + upgrade_type + "_pickup.png")
	draggable.info = load("res://pickups/upgrade_pickup/upgrade_resources/" + upgrade_type + "_upgrade.tres")

func assign_upgrade():
	var upgrade_num : int = randi_range(0, 3)
	if upgrade_num == 0:
		upgrade_type = "damage"
	if upgrade_num == 1:
		upgrade_type = "power"
	if upgrade_num == 2:
		upgrade_type = "clicker"
	if upgrade_num == 3:
		upgrade_type = "length"

func set_draggable():
	if active:
		draggable_shape.disabled = false
	else:
		draggable_shape.disabled = true

func used_up(used_draggable : Draggable):
	print("Okey ",  used_draggable, " and ", draggable)
	if draggable == used_draggable:
		queue_free()
