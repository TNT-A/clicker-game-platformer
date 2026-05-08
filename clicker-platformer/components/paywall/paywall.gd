extends Area2D
class_name  Paywall

@onready var label: Label = $Label

@export var host : Node2D 
@export var cost : int = 300
var hovered : bool = false

func _ready() -> void:
	set_label()

func set_label():
	label.text = str(cost) + "$"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and hovered and InfoManager.gold > cost:
		pay()
		remove_paywall()

func pay():
	InfoManager.gold -= cost

func remove_paywall():
	if is_instance_valid(host) and "active" in host:
		host.active = true
		if host.has_method("set_draggable"):
			host.set_draggable()
	queue_free()

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
