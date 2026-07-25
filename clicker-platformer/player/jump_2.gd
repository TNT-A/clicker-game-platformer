extends State
class_name Jump2State

@onready var platformer_move: Platformer = $"../../PlatformerMove"
@onready var ray_cast_r: RayCast2D = $"../../RayCastR"
@onready var ray_cast_l: RayCast2D = $"../../RayCastL"

func enter():
	parent_body.velocity.y = 0
	platformer_move.jump()
	parent_body.air_jump = false
	$"../../AnimationPlayer".play("RESET")
	$"../../AnimationPlayer".play("spin")

func exit():
	#parent_body.velocity.y = 0
	pass

func physics_update(_delta: float):
	#print(parent_body.velocity.y)
	if parent_body.velocity.y < 0:
		parent_body.velocity.y -= 2400 * _delta
	if parent_body.velocity.y > 0:
		parent_body.velocity.y += 1000 * _delta
	platformer_move.move()
	platformer_move.fall(_delta)
	check_transitions()

func check_transitions():
	if parent_body.is_on_floor():
		SignalBus.transitioned.emit(self, "Walk")
	if ray_cast_l.is_colliding() and Input.is_action_pressed("Move_Left"):
		SignalBus.transitioned.emit(self, "WallSlide")
	elif ray_cast_r.is_colliding() and Input.is_action_pressed("Move_Right"):
		SignalBus.transitioned.emit(self, "WallSlide")
	if parent_body.air_jump:
			SignalBus.transitioned.emit(self, "Jump2")
	if Input.is_action_just_pressed('Char_Ability'):
		SignalBus.transitioned.emit(self, "CharAbility" + parent_body.player_name_placeholder)
