extends Node2D
class_name Room

var room_started : bool = false
var room_ended : bool = false

func _on_camera_move_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#print("Hit!!!")
	if body.is_in_group("player"):
		#print("Hit Camera Room")
		SignalBus.move_camera.emit($CameraPos.global_position)

func _on_room_start_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and !room_started:
		#print("I should start timer")
		room_started = true
		$RoomStartTimer.start()

func _on_room_start_timer_timeout() -> void:
	#print("Timer should be done")
	SignalBus.room_started.emit(self)

		#SignalBus.room_ended.emit(4, self)
		#room_ended = true
		#print("I entered")
