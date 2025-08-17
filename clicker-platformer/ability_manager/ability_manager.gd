extends Node2D

var ability_list : Array[String] = [
	"basic_shot",
	"basic_slash",
	"basic_shield"
]

func _ready() -> void:
	SignalBus.ability_use.connect(use_ability)

func use_ability(num):
	var ability_callable = Callable(self, ability_list[num])
	ability_callable.call()

func basic_shot():
	print("*Shoots You")

func basic_slash():
	print("*Slashes You")

func basic_shield():
	print("*Protects You")
