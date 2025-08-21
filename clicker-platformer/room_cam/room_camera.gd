extends Camera2D

var at_pos : bool = true
var pos : Vector2

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)

func move_cam(new_pos):
	#print("I'm tryna move")
	pos = new_pos
	at_pos = false

func _physics_process(delta: float) -> void:
	if !at_pos:
		global_position = global_position.lerp(pos, 0.1)
