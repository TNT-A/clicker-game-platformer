extends State
class_name IdleState

@onready var platformer_move: Platformer = $"../../PlatformerMove"
@onready var ray_cast_r: RayCast2D = $"../../RayCastR"
@onready var ray_cast_l: RayCast2D = $"../../RayCastL"

func enter():
	parent_body.air_jump = true
	$"../../AnimationPlayer".play("RESET")
	$"../../AnimationPlayer".play("idle")
	#parent_body.velocity.y = 0

func exit():
	pass

func physics_update(_delta: float):
	platformer_move.move()
	platformer_move.fall(_delta)
	check_transitions()

func check_transitions():
	if Input.is_action_just_pressed("Move_Left") or Input.is_action_just_pressed("Move_Right"):
		SignalBus.transitioned.emit(self, "Walk")
	if Input.is_action_just_pressed("Move_Up"):
		if parent_body.is_on_floor():
			SignalBus.transitioned.emit(self, "Jump1")
		else:
			SignalBus.transitioned.emit(self, "Jump2")
	
	if ray_cast_l.is_colliding() and Input.is_action_pressed("Move_Left"):
		SignalBus.transitioned.emit(self, "WallSlide")
	elif ray_cast_r.is_colliding() and Input.is_action_pressed("Move_Right"):
		SignalBus.transitioned.emit(self, "WallSlide")

	
	if Input.is_action_just_pressed('Char_Ability'):
		SignalBus.transitioned.emit(self, "CharAbility" + parent_body.player_name_placeholder)
