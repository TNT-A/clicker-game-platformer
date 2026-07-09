extends Node2D

@export var click_offset : float = .3

@onready var autoclick_timer: Timer = $AutoclickTimer
var autoclick : bool = false

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Click"):
		#print("click")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ToggleAuto") and !autoclick:
		autoclick = true
	elif Input.is_action_just_pressed("ToggleAuto") and autoclick:
		autoclick = false
	if (Input.is_action_pressed("Click") or autoclick) and autoclick_timer.is_stopped():
		autoclick_timer.wait_time = click_offset
		autoclick_timer.start()
	if Input.is_action_just_released("Click"):
		autoclick_timer.stop()
	if Input.is_action_just_pressed("Click"):
		autoclick_timer.wait_time = click_offset
		autoclick_timer.start()

func simulate_click():
	SignalBus.autoclick.emit()
	#print("p")

func _on_timer_timeout() -> void:
	simulate_click()
