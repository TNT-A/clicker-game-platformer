extends Camera2D

var at_pos : bool = true
var pos : Vector2

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)

func move_cam(new_pos):
	#print("I'm tryna move")
	pos = new_pos
	at_pos = false
	SignalBus.camera_moved.emit(pos)

func _physics_process(delta: float) -> void:
	if !at_pos:
		global_position = global_position.lerp(pos, 0.1)
	if Input.is_action_just_pressed("Maximize"):
		zoom += Vector2(.1, .1)
	if Input.is_action_just_pressed("Minimize"):
		zoom -= Vector2(.1, .1)
