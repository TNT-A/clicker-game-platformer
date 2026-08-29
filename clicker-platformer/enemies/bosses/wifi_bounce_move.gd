extends State
class_name WifiBossBounce
 
@onready var wifi_boss: WifiBoss = $"../.."
@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var shot_component: ShotComponent = $"../../ShotComponent"
@onready var wifi_position_indicator: Sprite2D = $"../../WifiPositionIndicator"
@onready var node_animation_player: AnimationPlayer = $"../../NodeAnimationPlayer"
@onready var movement_indicator: Line2D = $"../../MovementIndicator"
@onready var state_machine: StateMachine = $".."

var velocity : Vector2
@export var base_speed : float = 150
var speed : float = 100
@export var bounce_rando_magnitude : float = 15
var spinning : bool = false
var total_bounces : int = 7
var dir : Vector2 

func enter():
	total_bounces = randi_range(7, 10)
	spinning = false
	speed = base_speed
	boss_animation_player.play("spin", 0, 2)
	var temp_dir : Vector2 = start_spin()
	await get_tree().create_timer(1).timeout
	#var tween = get_tree().create_tween()
	#tween.set_trans(Tween.TRANS_EXPO)
	#tween.tween_property(sprite_2d, "position", temp_dir * -30, 1)
	#await tween.finished
	#tween.stop()
	#tween.tween_property(sprite_2d, "position", Vector2(0, 0), .5)
	spinning = true
	#sprite_2d.position = Vector2(0, 0)

func start_spin():
	var rand_x : int = randi_range(0, 1)
	var rand_y : int = randi_range(0, 1)
	if rand_x == 0:
		rand_x = -1
	if rand_y == 0:
		rand_y = -1
	dir = Vector2(rand_x, rand_y).normalized()
	velocity = dir * speed
	return dir

func bounce(cur_collision : KinematicCollision2D):
	total_bounces -= 1
	if is_instance_valid(cur_collision):
		wifi_boss.wifi_shot_1()
		dir = dir.bounce(cur_collision.get_normal())
		speed_up()
		velocity = dir * speed
	if total_bounces <= 0:
		print(total_bounces)
		spinning = false
		transition_to_move()

func transition_to_move():
	boss_animation_player.play("icon_to_face")
	await wifi_boss.set_pos_index(0)
	wifi_position_indicator.global_position = wifi_boss.next_position
	wifi_position_indicator.global_position.y -= 20
	node_animation_player.play("wifi_node_land")
	set_line()
	await get_tree().create_timer(1.8).timeout
	boss_animation_player.play("face_to_icon")

func set_line():
	movement_indicator.clear_points()
	movement_indicator.add_point(wifi_boss.global_position)
	movement_indicator.add_point(wifi_position_indicator.position)

func speed_up():
	speed += base_speed * 0.20
	if speed >= base_speed * 3:
		speed = base_speed * 3

func exit():
	$"../WifiIdle".bounce_chance = 0
	wifi_boss.velocity = Vector2(0, 0)

func update(_delta: float):
	pass

func physics_update(_delta: float):
	if spinning:
		var collision = wifi_boss.move_and_collide(velocity * _delta)
		if collision:
			bounce(collision)

func _on_boss_animation_player_animation_finished(anim_name: StringName) -> void:
	if state_machine.current_state == self and anim_name == "face_to_icon" and total_bounces <= 0:
		node_animation_player.play("wifi_node_rise")
		SignalBus.transitioned.emit(self, "WifiMove")
