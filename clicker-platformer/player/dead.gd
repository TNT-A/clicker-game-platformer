extends State
class_name DeadState

@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"
@onready var main_character: Player = $"../.."
@onready var ability_manager: AbilityManager = $"../../AbilityManager"
@onready var platformer_move: Platformer = $"../../PlatformerMove"
@onready var state_machine: StateMachine = $".."

func enter():
	collision_shape_2d.disabled = true
	main_character.velocity = Vector2.ZERO
	ability_manager.can_use_abilities = false
	platformer_move.jump()

func _process(delta: float) -> void:
	if state_machine.current_state == self:
		platformer_move.fall(delta)
