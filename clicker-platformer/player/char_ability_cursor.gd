extends State
class_name CharFloatState

@onready var platformer_move: Platformer = $"../../PlatformerMove"
@onready var ability_manager: AbilityManager = $"../../AbilityManager"

func enter():
	ability_manager.can_use_abilities = false
	parent_body.air_jump = true
	parent_body.velocity.y = 0
	$"../../AnimationPlayer".play("walk")
	parent_body.scale = Vector2(.6, .6)

func exit():
	parent_body.scale = Vector2(1, 1)
	ability_manager.can_use_abilities = true

func physics_update(_delta: float):
	platformer_move.omni_move()
	check_transitions()

func check_transitions():
	if !Input.is_action_pressed("Char_Ability"):
		SignalBus.transitioned.emit(self, "Idle")
