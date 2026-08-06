extends CharacterBody2D
class_name Enemy

@export var enemy_name : String = "Template"

@export var max_health : int = 3
@export var health : int = 3
@export var damage : int = 1

@export var is_boss : bool = false

var gold : int = 10

func flash():
	if is_boss:
		SignalBus.boss_hit.emit()

func die():
	#print("I'm dying")
	SignalBus.enemy_killed.emit(self)
	var rand_num = randi_range(0,3)
	if rand_num == 3:
		gold = 30
	InfoManager.gold += gold
	queue_free()
