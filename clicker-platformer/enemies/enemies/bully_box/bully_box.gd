extends Enemy

var vertical_time : bool = true
var can_dash : bool = false
var dashing : bool = false

var cooldown : float = 1.0
var base_cooldown : float = 1.0
var speed : int = 200

func _physics_process(delta: float) -> void:
	#if dashing:
		#if is_on_wall() or is_on_ceiling() or is_on_floor():
			#dashing = false
			#velocity = Vector2(0,0)
	move_and_slide()

func _ready() -> void:
	var rand_num = randi_range(0,1)
	if rand_num == 1:
		vertical_time = true
	else:
		vertical_time = false
	cooldown = randf_range(base_cooldown-.1, base_cooldown +.2)
	$CooldownTimer.wait_time = cooldown
	$CooldownTimer.start()

func _on_cooldown_timer_timeout() -> void:
	velocity = Vector2(0,0)
	await get_tree().create_timer(1).timeout
	var player_dir = (InfoManager.player.global_position - global_position).normalized()
	if player_dir.y > -0:
		player_dir.y = 1
	if player_dir.y < 0:
		player_dir.y = -1
	if player_dir.x > -0:
		player_dir.x = 1
	if player_dir.x < 0:
		player_dir.x = -1
	if vertical_time: 
		vertical_time = false
		velocity.y = player_dir.y * speed
		velocity.x = 0
		#print(player_dir)
	elif !vertical_time:
		vertical_time = true
		velocity.x = player_dir.x * speed
		velocity.y = 0
		#print(player_dir)
	dashing = true
	cooldown = randf_range(base_cooldown-.1, base_cooldown +.2)
	$CooldownTimer.wait_time = cooldown
	$CooldownTimer.start()
