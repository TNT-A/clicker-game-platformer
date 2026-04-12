extends Area2D
class_name DragZone

@export var host : Node

func _ready() -> void:
	SignalBus.drag_recieved.connect(recieve_info)

func recieve_info(drag_zone : Area2D, drag_info : Resource, draggable : Draggable):
	if drag_zone == self:
		use_info(drag_info, draggable)

func use_info(drag_info : Resource, draggable : Draggable):
	print("OH YEA!!!!!")
	SignalBus.forward_to_host.emit(host, drag_info, draggable)
