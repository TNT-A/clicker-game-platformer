extends State
class_name WifiBossBounce
 
@onready var wifi_boss: WifiBoss = $"../.."
@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var shot_component: ShotComponent = $"../../ShotComponent"

var velocity : Vector2
@export var base_speed : float = 200
var speed : float = 100
@export var bounce_rando_magnitude : float = 15
var spinning : bool = false

func enter():
	spinning = false
	speed = base_speed
	boss_animation_player.play("spin", 0, 2)
	var temp_dir : Vector2 = start_spin()
	#await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(sprite_2d, "position", temp_dir * -30, 1)
	await tween.finished
	tween.stop()
	tween.tween_property(sprite_2d, "position", Vector2(0, 0), .5)
	spinning = true
	#sprite_2d.position = Vector2(0, 0)

func start_spin():
	var rand_x : int = randi_range(0, 1)
	var rand_y : int = randi_range(0, 1)
	if rand_x == 0:
		rand_x = -1
	if rand_y == 0:
		rand_y = -1
	var dir : Vector2 = Vector2(rand_x, rand_y).normalized()
	velocity = dir * speed
	return dir

func bounce(cur_collision : KinematicCollision2D):
	if is_instance_valid(cur_collision):
		wifi_boss.wifi_shot_1()
		velocity = velocity.bounce(cur_collision.get_normal())
		speed_up()

func speed_up():
	speed += base_speed * 0.2
	if speed >= base_speed * 3:
		speed = base_speed * 3

func exit():
	wifi_boss.velocity = Vector2(0, 0)

func update(_delta: float):
	pass

func physics_update(_delta: float):
	if spinning:
		var collision = wifi_boss.move_and_collide(velocity * _delta)
		if collision:
			bounce(collision)

#func _on_boss_animation_player_current_animation_changed(name: String) -> void:
	#print(name)
