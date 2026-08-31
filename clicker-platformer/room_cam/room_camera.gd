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
var following : bool = false
var gentle_following : bool = false

func _ready() -> void:
	SignalBus.move_camera.connect(move_cam)
	SignalBus.stop_camera.connect(stop_cam)
	
	#SignalBus.shake_screen.connect(shake)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Debug"):
		#if !debug:
			#debug = true
			#limit_enabled = false
		#else:
			#debug = false
			#limit_enabled = true
	##if event.is_action_pressed("Debug"):
		##stop_cam() 

func stop_cam():
	following = false

func move_cam(new_pos, margins : Dictionary):
	#limit_enabled = false
	cam_limits = margins.duplicate(true)
	print(new_pos.y, " | ", global_position.y)
	#limit_right = cam_limits["right"]
	#limit_bottom = cam_limits["down"] 
	if new_pos:
		if new_pos.y > global_position.y:
			limit_right = cam_limits["right"]
			limit_bottom = cam_limits["down"]
		else:
			limit_right = cam_limits["right"]
			limit_top = cam_limits["up"]
	pos = InfoManager.player.global_position
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", pos, .8)
	tween.parallel().tween_property(self, "zoom", Vector2(.5, .5), .4)
	tween.tween_property(self, "zoom", Vector2(1, 1), .4)
	await tween.finished
	tween.kill()
	following = true
	gentle_following = true
	
	limit_right = cam_limits["right"]
	limit_bottom = cam_limits["down"]
	limit_top = cam_limits["up"]
	limit_left = cam_limits["left"]# + InfoManager.cam_pivot.x 
	#limit_enabled = true

func cam_follow():
	if following and gentle_following:
		global_position = global_position.lerp(InfoManager.player.global_position, .6)
		if global_position.is_equal_approx(InfoManager.player.global_position):
			gentle_following = false
	else:
		global_position = global_position.lerp(InfoManager.player.global_position, .2)

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
