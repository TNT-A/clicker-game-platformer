extends Control

@onready var label: Label = $VBoxContainer/Label
@onready var progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBar

@export var ability_type : Resource
var ability_name : String = "base"
var ability_max : int = 10
var ability_num : int = 1

var default_size : Vector2 = Vector2(92, 20)
var expand_size : Vector2 = Vector2(92, 40)

var level : int = 0
var clicks : int = 0

var active : bool = false
var selected : bool = false

func _ready() -> void:
	await InfoManager.clicker_panel
	SignalBus.update_selected.connect(update)
	
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max_values[level]
		ability_num = ability_type.ability_num
	
	label.text = ability_name
	progress_bar.max_value = ability_max

func update():
	if active:
		visible = true
	else: 
		visible = false
	if selected:
		$BasePanel.visible = false
		$ExpandPanel.visible = true
		custom_minimum_size = expand_size
	else:
		$BasePanel.visible = true
		$ExpandPanel.visible = false
		custom_minimum_size = default_size

func click():
	clicks += InfoManager.click_power
	update_bar()

func update_bar():
	progress_bar.value = clicks
	if progress_bar.value >= progress_bar.max_value:
		SignalBus.ability_use.emit(ability_num)
		reset_bar()

func reset_bar():
	progress_bar.value = 0
	clicks = 0
	update_bar()

func _on_button_power_pressed() -> void:
	pass # Replace with function body.

func _on_button_clicker_pressed() -> void:
	pass # Replace with function body.

func _on_button_length_pressed() -> void:
	pass # Replace with function body.

func upgrade_power():
	pass

func add_autoclicker():
	pass

func decrease_max():
	pass
