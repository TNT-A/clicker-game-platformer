extends Enemy

var target_1 : Vector2 = Vector2(120,50)
var target_2 : Vector2 = Vector2(240,50)

var at_target_1 : bool = true
var at_target_2 : bool = false

var base_attack_speed : float = 5.0
var attack_speed : float = 5.0
var base_speed : int = 120
var speed : int = 120
var radius : int = 40

func _ready() -> void:
	speed = randi_range(base_speed - 40, base_speed + 40)
	attack_speed = randf_range(base_attack_speed - 1.0, base_attack_speed + 2.0)
	$AttackTimer.wait_time = attack_speed
	$AttackTimer.start()

func _physics_process(delta: float) -> void:
	if is_instance_valid(InfoManager.player):
		target_1.x = InfoManager.player.global_position.x - radius
		target_2.x = InfoManager.player.global_position.x + radius
		target_1.y = InfoManager.player.global_position.y - 90
		target_2.y = InfoManager.player.global_position.y - 90
	var dir : Vector2
	var dist : float
	if at_target_1:
		dir = (target_2 - global_position).normalized()
		dist = global_position.distance_to(target_2)
		velocity = velocity.lerp(speed*dir,0.05)
		if dist <= 20:
			at_target_1 = false
			at_target_2 = true
	else:
		dir = (target_1 - global_position).normalized()
		dist = global_position.distance_to(target_1)
		velocity = velocity.lerp(speed*dir,0.1)
		if dist <= 20:
			at_target_1 = true
			at_target_2 = false
	move_and_slide()

func attack():
	$ShotComponent.create_shot(Vector2(0,1), 160, damage)

func _on_speed_timer_timeout() -> void:
	speed = randi_range(base_speed - 40, base_speed + 40)

func _on_attack_timer_timeout() -> void:
	attack()
	attack_speed = randf_range(base_attack_speed - 1.0, base_attack_speed + 2.0)
