#CURRENT WORK:
#CHANGE IT SO THAT THE ROOM CAMERA RECIEVES UNCHANGED MARGIN DATA, THEN CHANGES IT ITSELF IF NEEDED INSTEAD OF VICE VERSA

extends Camera2D
class_name RoomCamera

var pos : Vector2
var cam_limits : Dictionary[String, float] = {
	"up" : 0, 
	"down" : 0, 
	"left" : 0, 
	"right" : 0, 
}

@export var debug : bool = false

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)
	
	#SignalBus.shake_screen.connect(shake)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug"):
		if !debug:
			debug = true
			limit_enabled = false
		else:
			debug = false
			limit_enabled = true

func move_cam(new_pos, margins : Dictionary):
	cam_limits = margins.duplicate(true)
	limit_left = cam_limits["left"]# + InfoManager.cam_pivot.x 
	limit_right = cam_limits["right"]# + InfoManager.cam_pivot.x
	limit_bottom = cam_limits["down"]
	limit_top = cam_limits["up"]
	pos = new_pos# + InfoManager.cam_pivot
	global_position = pos

func cam_follow():
	global_position = InfoManager.player.global_position
	#var viewport_dimensions : Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	#var cam_pos : Vector2 = Vector2(0, 0)
	#cam_pos.x = clamp(cam_pos, cam_limits["right"], cam_limits["left"])
	#cam_pos.y = clamp(cam_pos, cam_limits["up"], cam_limits["down"])
	#position = cam_pos

func _physics_process(delta: float) -> void:
	if !debug:
		cam_follow()
	else:
		if Input.is_action_just_pressed("Maximize"):
			zoom *= 2
		if Input.is_action_just_pressed("Minimize"):
			zoom /= 2
		if Input.is_action_pressed("ui_up"):
			position.y -= 16
		if Input.is_action_pressed("ui_down"):
			position.y += 16
		if Input.is_action_pressed("ui_left"):
			position.x -= 16
		if Input.is_action_pressed("ui_right"):
			position.x += 16
