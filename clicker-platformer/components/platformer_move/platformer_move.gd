extends Node2D
class_name Platformer

const GRAVITY : float = 2200
const FALL_GRAVITY : float = 2500
const JUMP_POWER : float = 800
const JUMP_ACCELERATION : float = 0.75

@export var host : CharacterBody2D
@export var speed : int = 300
@export var acceleration : float = 0.2

var accept_input : bool = true

func _physics_process(delta: float) -> void:
	if host.is_alive:
		speed = get_parent().speed
		#move()
		fall(delta)
		host.move_and_slide()
		if Input.is_action_pressed("Move_Down"):
			host.set_collision_mask_value(2, false)
		else:
			host.set_collision_mask_value(2, true)

func jump():
	host.velocity.y = -JUMP_POWER

func fall(delta):
	host.velocity.y += get_gravity() * delta
	#print(host.velocity)

func get_gravity():
	if host.velocity.y > 0:
		#print("gave heavy")
		return FALL_GRAVITY
	else:
		#print("gave light")
		return GRAVITY

func get_direction():
	var input : Vector2 = Vector2()
	if Input.is_action_pressed("Move_Left"):
		input.x -=1
	if Input.is_action_pressed("Move_Right"):
		input.x +=1
	return input

func move():
	var dir = get_direction()
	host.velocity = host.velocity.lerp(dir * speed, acceleration)
	if host.velocity.x > 0:
		$"../Sprite2D".flip_h = false
	else:
		$"../Sprite2D".flip_h = true
