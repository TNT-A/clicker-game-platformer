extends Room

#func _on_camera_move_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body.is_in_group("player"):
		#SignalBus.move_camera.emit($CameraPos.global_position)
