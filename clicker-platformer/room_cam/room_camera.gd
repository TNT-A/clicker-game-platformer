extends Camera2D
class_name RoomCamera

var at_pos : bool = true
var pos : Vector2

var trauma : float = 0.0
var shake_amount : float = 0.5

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)
	#SignalBus.shake_screen.connect(shake)

func move_cam(new_pos):
	#print("I'm tryna move")
	pos = new_pos
	at_pos = false
	SignalBus.camera_moved.emit(pos)

func _physics_process(delta: float) -> void:
	if !at_pos:
		global_position = global_position.lerp(pos, 0.1)
	if trauma > 0:
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		position += shake_offset
		trauma -= delta * 0.5  # Decrease trauma over time
	if Input.is_action_just_pressed("Maximize"):
		zoom *= 2
	if Input.is_action_just_pressed("Minimize"):
		zoom /= 2
 
#func shake(intensity: float, shake_a: float):
	#shake_amount = shake_a
	#trauma += intensity
