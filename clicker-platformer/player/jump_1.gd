extends State
class_name Jump1State

@onready var platformer_move: Platformer = $"../../PlatformerMove"

func enter():
	parent_body.air_jump = true
	platformer_move.jump()
	$"../../AnimationPlayer".play("RESET")
	$"../../AnimationPlayer".play("jump")

func exit():
	pass

func physics_update(_delta: float):
	#print(parent_body.velocity.y)
	if Input.is_action_pressed("Move_Up") and parent_body.velocity.y < 0:
		parent_body.velocity.y -= 2400 * _delta
	#if Input.is_action_just_released("Move_Up") and parent_body.velocity.y < 0:
		#parent_body.velocity.y = parent_body.velocity.y/3
	if parent_body.velocity.y > 0:
		parent_body.velocity.y += 1000 * _delta
		#print("CUUUUT")
	platformer_move.move()
	check_transitions()

func check_transitions():
	if parent_body.is_on_floor():
		SignalBus.transitioned.emit(self, "Walk")
		#print("I'm on the floor")
	
	#if Input.is_action_just_released("Move_Up") or parent_body.velocity.y <= -460:
		#SignalBus.transitioned.emit(self, "Fall")
		#print("I released the button: ", parent_body.velocity.y)
	
	if Input.is_action_just_pressed("Move_Up"):
		if parent_body.is_on_wall_only():
			SignalBus.transitioned.emit(self, "Jump1")
		elif parent_body.air_jump:
			SignalBus.transitioned.emit(self, "Jump2")
