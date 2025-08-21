extends CharacterBody2D
class_name Enemy

@export var health : int = 3
@export var damage : int = 1

func flash():
	print("I'm flashing")

func die():
	print("I'm dying")
	queue_free()
