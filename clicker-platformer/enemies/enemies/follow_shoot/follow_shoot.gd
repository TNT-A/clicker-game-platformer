extends Enemy

var dir : Vector2
@export var base_speed : int = 65 
var speed = 65
var recoil : bool = false

func _ready() -> void:
	speed = randi_range(base_speed-25, base_speed+15)

func _physics_process(delta: float) -> void:
	if !recoil:
		dir = (InfoManager.player.global_position - global_position).normalized()
	if recoil:
		dir = (global_position - InfoManager.player.global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func _on_damage_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#print("Body Entered")
	if body is Player:
		await get_tree().create_timer(.2).timeout
		recoil = true
		$RecoilTimer.start()

func _on_recoil_timer_timeout() -> void:
	recoil = false
	speed = randi_range(base_speed-25, base_speed+15)
