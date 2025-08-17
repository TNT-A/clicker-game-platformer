extends State
class_name Jump2State

@onready var platformer_move: Platformer = $"../../PlatformerMove"

func enter():
	parent_body.air_jump = false

func exit():
	pass

func physics_update(_delta: float):
	platformer_move.move()
	platformer_move.jump()
	check_transitions()

func check_transitions():
	if parent_body.is_on_floor():
		SignalBus.transitioned.emit(self, "Walk")
	if Input.is_action_just_pressed("Move_Up") and parent_body.is_on_wall_only():
			SignalBus.transitioned.emit(self, "Jump1")
