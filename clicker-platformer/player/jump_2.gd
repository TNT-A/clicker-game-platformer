extends State
class_name Jump2State

@onready var platformer_move: Platformer = $"../../PlatformerMove"

func enter():
	parent_body.velocity.y = 0
	platformer_move.jump()
	parent_body.air_jump = false

func exit():
	#parent_body.velocity.y = 0
	pass

func physics_update(_delta: float):
	print(parent_body.velocity.y)
	if Input.is_action_pressed("Move_Up") and parent_body.velocity.y < 0:
		parent_body.velocity.y -= 3200 * _delta
	if Input.is_action_just_released("Move_Up") and parent_body.velocity.y < 0:
		parent_body.velocity.y = parent_body.velocity.y/3
	if parent_body.velocity.y > 0:
		parent_body.velocity.y += 1000 * _delta

	platformer_move.move()
	check_transitions()

func check_transitions():
	if parent_body.is_on_floor():
		SignalBus.transitioned.emit(self, "Walk")
	if Input.is_action_just_pressed("Move_Up") and parent_body.is_on_wall_only():
			SignalBus.transitioned.emit(self, "Jump1")
