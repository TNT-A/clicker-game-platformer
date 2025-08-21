extends State
class_name IdleState

@onready var platformer_move: Platformer = $"../../PlatformerMove"

func enter():
	parent_body.air_jump = true
	$"../../AnimationPlayer".play("RESET")
	$"../../AnimationPlayer".play("idle")
	#parent_body.velocity.y = 0

func exit():
	pass

func physics_update(_delta: float):
	platformer_move.move()
	#platformer_move.fall(_delta)
	check_transitions()

func check_transitions():
	if Input.is_action_just_pressed("Move_Left") or Input.is_action_just_pressed("Move_Right"):
		SignalBus.transitioned.emit(self, "Walk")
	if Input.is_action_just_pressed("Move_Up"):
		if parent_body.is_on_floor():
			SignalBus.transitioned.emit(self, "Jump1")
		else:
			SignalBus.transitioned.emit(self, "Jump2")
