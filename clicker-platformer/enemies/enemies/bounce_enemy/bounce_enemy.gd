extends Enemy

var dir = Vector2(1,1)
var speed : int = 80

var can_bounce : bool = true

func _ready() -> void:
	var rand_num = randi_range(0,3)
	if rand_num == 0:
		dir = Vector2(-1,1)
	if rand_num == 1:
		dir = Vector2(1,1)
	if rand_num == 2:
		dir = Vector2(-1,-1)
	if rand_num == 3:
		dir = Vector2(1,-1)

func _physics_process(delta: float) -> void:
	if is_on_wall() and can_bounce:
		dir.x *= -1
		can_bounce = false
		$BounceTimer.start()
	if (is_on_ceiling() or is_on_floor()) and can_bounce:
		dir.y *= -1
		can_bounce = false
		$BounceTimer.start()
	velocity = dir*speed
	move_and_slide()

func _on_bounce_timer_timeout() -> void:
	can_bounce = true
