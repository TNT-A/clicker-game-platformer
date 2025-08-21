extends Control

@onready var label: Label = $HBoxContainer/CenterContainer2/Panel/Label
@onready var base_text : String = label.text

var level : int = 0
var base_price : int = 25
var price : int = 25
var upgrade_scaling : float = 1.6

func _physics_process(delta: float) -> void:
	label.text = base_text + str(InfoManager.gold)
	hover_effects()

func hover_effects():
	$HBoxContainer/CenterContainer/Button/Label.text = str(price)
	if $HBoxContainer/CenterContainer/Button.is_hovered():
		$HBoxContainer/CenterContainer/Button/Label.visible = true
	else:
		$HBoxContainer/CenterContainer/Button/Label.visible = false

func _on_button_pressed() -> void:
	if InfoManager.gold >= price:
		clicker_upgrade()
		InfoManager.gold -= price
		increase_price()

func clicker_upgrade():
	level += 1
	InfoManager.click_power += 1

func increase_price():
	price *= upgrade_scaling + (randf_range(-.1, .1))
