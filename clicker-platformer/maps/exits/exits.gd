extends Node2D

func _ready() -> void:
	SignalBus.room_ended.connect(open_exits)

func open_exits(num:int, room):
	if room == get_parent():
		if num >= 1:
			$AnimationPlayer1.play("open_down_l")
			print(1)
		if num >= 2:
			$AnimationPlayer2.play("open_down_r")
			print(2)
		if num >= 3:
			$AnimationPlayer3.play("open_right")
			print(3)
		if num >= 4:
			$AnimationPlayer4.play("open_left")
			print(4)
