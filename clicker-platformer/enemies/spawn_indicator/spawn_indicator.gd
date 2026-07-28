extends Node2D
class_name SpawnIndicator

var is_boss : bool
var enemy_to_spawn : PackedScene
var spawn_pos : Vector2

func _on_wait_timer_timeout() -> void:
	var new_enemy = enemy_to_spawn.instantiate()
	new_enemy.global_position = spawn_pos
	get_parent().call_deferred("add_child", new_enemy)
	SignalBus.enemy_spawned.emit(new_enemy, is_boss)
	queue_free()
