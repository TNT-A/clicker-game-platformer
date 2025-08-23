extends CharacterBody2D
class_name Enemy

@export var health : int = 3
@export var damage : int = 1

var gold : int = 10

func flash():
	#print("I'm flashing")
	pass

func die():
	#print("I'm dying")
	SignalBus.enemy_killed.emit(self)
	var rand_num = randi_range(0,3)
	if rand_num == 3:
		gold = 30
	InfoManager.gold += gold
	queue_free()
