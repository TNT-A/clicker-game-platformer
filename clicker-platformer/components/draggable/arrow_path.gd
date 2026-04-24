extends Path2D

@onready var line_2d: Line2D = $Line2D
@onready var arrow_path: Path2D = $"."

func _process(delta: float) -> void:
	var mousePos = get_global_mouse_position() - position
	arrow_path.curve.set_point_position(0, Vector2(0,0))
	var outX = mousePos.x/4
	arrow_path.curve.set_point_out(0, Vector2(outX, -outX))
	
	arrow_path.curve.set_point_position(1, mousePos)
	arrow_path.curve.set_point_in(1, Vector2(-outX, -outX))
	
	line_2d.points = arrow_path.curve.get_baked_points()
