extends Area2D
class_name Draggable

#Component for creating an invisible dragger for sending resource info to drag_zone nodes
#Built for swapping abilities or getting abilities from pickups
#Prob will be worked for upgrading abilities as well
#!!! Draggable Line is kinda jank when first clicked

@onready var arrow_path: Path2D = $CanvasLayer/ArrowPath
@onready var line_2d: Line2D = $CanvasLayer/ArrowPath/Line2D

var home_pos : Vector2 = Vector2(0, 0)
var hovered : bool = false
var dragged : bool = false

var target_zone : Area2D = null

@export var info : Resource
@export var host : Node

func _ready() -> void:
	home_pos = global_position

func _physics_process(delta: float) -> void:
	if dragged:
		$Target.global_position = get_global_mouse_position()
		create_line()
	else:
		line_2d.visible = false
		$Target.global_position = home_pos

func create_line():
	#Could use some tweaking, but works fine
	line_2d.visible = true
	var mousePos = get_global_mouse_position()
	var startPos = global_position
	#if host:
		#startPos = host.position
	arrow_path.curve.set_point_position(0, startPos)
	var outX = mousePos.x/4
	arrow_path.curve.set_point_out(0, Vector2(outX, -outX))
	
	arrow_path.curve.set_point_position(1, mousePos)
	arrow_path.curve.set_point_in(1, Vector2(-outX, -outX))
	
	line_2d.points = arrow_path.curve.get_baked_points()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		#print("click")
		if hovered:
			dragged = true
	if event.is_action_released("Click"):
		#print("released")
		if is_instance_valid(target_zone):
			SignalBus.drag_recieved.emit(target_zone, info, self)
		dragged = false

func _on_mouse_entered() -> void:
	hovered = true
	#print("hovered")

func _on_mouse_exited() -> void:
	hovered = false
	#print("unhovered")

func _on_target_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("dragzone"):
		target_zone = area

func _on_target_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("dragzone"):
		if target_zone == area:
			target_zone = null
