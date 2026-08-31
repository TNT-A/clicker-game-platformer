extends Node2D
class_name RoomTransitioner

@export var move_to_shop : bool = false
@onready var color_rect: TextureRect = $ColorRect

@export var cur_room_slot : int = 0
@export var to_room_slot : int = 0

var dir : Vector2 = Vector2(0, 0)

func _ready() -> void:
	#print(dir)
	if dir == Vector2(0.5, 0):
		#print("Yahaha!")
		color_rect.texture = load("res://sprites/room_transitioner/room_transition_folder_up.png")

func swap_room():
	if move_to_shop:
		SignalBus.swap_to_shop.emit()
	else:
		SignalBus.stop_camera.emit()
		SignalBus.swap_by_slot.emit(cur_room_slot, to_room_slot)

func _on_clickable_clickable_used() -> void:
	swap_room()

func _on_clickable_clickable_hovered() -> void:
	#print("Position: " + str(position) + " / Global Position: " + str(global_position))
	pass
