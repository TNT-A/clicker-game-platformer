extends Enemy

const GRAVITY : float = 600
const JUMP_POWER : float = 500
const JUMP_ACCELERATION : float = 0.75

@export var base_speed : int = 100
var speed : int = 100
@export var acceleration : float = 0.2

var turned : bool = false
var dir = -1

func _ready() -> void:
	speed = randi_range(base_speed - 40, base_speed + 20)
	var rand_num = randi_range(0,1)
	if rand_num == 0:
		dir = 1
	else: 
		dir = -1

func _physics_process(delta: float) -> void:
	velocity.x = dir * speed
	if is_on_wall() and !turned:
		turned = true
		$TurnTimer.start()
		dir *= -1
	fall(delta)
	move_and_slide()
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func jump():
	velocity.y = -JUMP_POWER

func fall(delta):
	velocity.y += GRAVITY * delta

func _on_turn_timer_timeout() -> void:
	turned = false
	#jump()
