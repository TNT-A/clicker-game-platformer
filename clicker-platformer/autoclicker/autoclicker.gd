extends Node2D
class_name Autoclicker

var parent_ability : Control

var timer_length : float = 1.0

var timer_pos
var distance

var starting_point : Vector2 = Vector2(10, 30)
var current_point : Vector2
var ending_point : Vector2 = Vector2(50, 30)

func _ready() -> void:
	#$Timer.wait_time = randf_range(timer_length - 0.1, timer_length + 0.1)
	$Timer.start()
	$Indicator.visible = true

func _physics_process(delta: float) -> void:
	$start.global_position = starting_point
	$end.global_position = ending_point
	
	starting_point.y = parent_ability.get_global_rect().position.y + 8
	ending_point.y = parent_ability.get_global_rect().position.y + 8
	
	timer_pos =  $Timer.wait_time - $Timer.time_left / $Timer.wait_time 
	distance = ending_point.x -2 - starting_point.x
	current_point = Vector2(distance * timer_pos + starting_point.x, ending_point.y)
	$Indicator.global_position = current_point

func _on_timer_timeout() -> void:
	if parent_ability:
		parent_ability.autoclick()
	#print(current_point, " ", $Indicator.global_position, " ", $end.global_position)
	await get_tree().create_timer(randf_range(.1, .4)).timeout
	#$Timer.wait_time = randf_range(timer_length - 0.1, timer_length + 0.1)
	$Timer.start()
