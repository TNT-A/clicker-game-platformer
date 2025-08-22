extends CharacterBody2D
class_name Enemy

@export var health : int = 3
@export var damage : int = 1

func flash():
	#print("I'm flashing")
	pass

func die():
	#print("I'm dying")
	SignalBus.enemy_killed.emit(self)
	queue_free()
