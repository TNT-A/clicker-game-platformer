#CURRENT WORK:
#CHANGE IT SO THAT THE ROOM CAMERA RECIEVES UNCHANGED MARGIN DATA, THEN CHANGES IT ITSELF IF NEEDED INSTEAD OF VICE VERSA

extends Camera2D
class_name RoomCamera

var pos : Vector2
var cam_margins : Dictionary[String, float] = {
	"up" : 0, 
	"down" : 0, 
	"left" : 0, 
	"right" : 0, 
}

@export var debug : bool = false

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)
	#SignalBus.shake_screen.connect(shake)

func move_cam(new_pos, margins : Dictionary):
	#print("I'm tryna move")
	cam_margins = margins.duplicate(true)
	if cam_margins["right"] != 0 or cam_margins["left"] != 0:
		print('yep')
		cam_margins["right"] += InfoManager.cam_pivot.x
	pos = new_pos - InfoManager.cam_pivot
	global_position = pos

func cam_follow():
	global_position = InfoManager.player.global_position
	
	if global_position.x > pos.x + cam_margins["right"]:
		global_position.x = pos.x + cam_margins["right"]
	if global_position.x <= pos.x - cam_margins["left"]:
		global_position.x = pos.x - cam_margins["left"]
	
	if global_position.y > pos.y + cam_margins["down"]:
		global_position.y = pos.y + cam_margins["down"]
	if global_position.y <= pos.y - cam_margins["up"]:
		global_position.y = pos.y - cam_margins["up"]

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
