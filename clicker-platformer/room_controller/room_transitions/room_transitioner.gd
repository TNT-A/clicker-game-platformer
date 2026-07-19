extends Node2D
class_name RoomTransitioner

@export var cur_room_slot : int = 0
@export var to_room_slot : int = 0

func swap_room():
	SignalBus.swap_by_slot.emit(cur_room_slot, to_room_slot)

func _on_clickable_clickable_used() -> void:
	swap_room()

func _on_clickable_clickable_hovered() -> void:
	print("Position: " + str(position) + " / Global Position: " + str(global_position))
