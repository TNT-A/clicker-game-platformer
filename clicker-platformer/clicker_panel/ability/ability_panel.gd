extends Control

@onready var label: Label = $VBoxContainer/Label
@onready var progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBar

@onready var label_min: Label = $VBoxContainer/HBoxContainer/LabelMin
@onready var label_max: Label = $VBoxContainer/HBoxContainer/LabelMax

@onready var autoclicker_hub: Node2D = $AutoclickerHub

@export var ability_type : Resource
var ability_name : String = "base"
var ability_max : int = 10
var ability_num : int = 1
var ability_damage : float = 1

var default_size : Vector2 = Vector2(92, 28)
var expand_size : Vector2 = Vector2(92, 46)

var power_level : int = 0
var clicker_level : int = 0
var length_level : int = 0

var attack_bonus : float = 0
var length_lower : int = 0

var upgrade_price : int = 10
var power_price : int = 10
var clicker_price : int = 10
var length_price : int = 10
var upgrade_scaling : float = 1.3

var clicks : int = 0

var active : bool = false
var selected : bool = false

func _ready() -> void:
	await InfoManager.clicker_panel
	SignalBus.update_selected.connect(update)
	
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max
		ability_num = ability_type.ability_num
	
	label.text = ability_name
	progress_bar.max_value = ability_max

func _physics_process(delta: float) -> void:
	hover_effects()

func hover_effects():
	$ExpandPanel/HBoxContainer/ButtonPower/PowerPrice.text = str(power_price)
	$ExpandPanel/HBoxContainer/ButtonLength/LengthPrice.text = str(length_price)
	$ExpandPanel/HBoxContainer/ButtonClicker/ClickerPrice.text = str(clicker_price)

	if $ExpandPanel/HBoxContainer/ButtonPower.is_hovered():
		$ExpandPanel/HBoxContainer/ButtonPower/PowerPrice.visible = true
	else: 
		$ExpandPanel/HBoxContainer/ButtonPower/PowerPrice.visible = false
	if $ExpandPanel/HBoxContainer/ButtonLength.is_hovered():
		$ExpandPanel/HBoxContainer/ButtonLength/LengthPrice.visible = true
	else:
		$ExpandPanel/HBoxContainer/ButtonLength/LengthPrice.visible = false
	if $ExpandPanel/HBoxContainer/ButtonClicker.is_hovered():
		$ExpandPanel/HBoxContainer/ButtonClicker/ClickerPrice.visible = true
	else:
		$ExpandPanel/HBoxContainer/ButtonClicker/ClickerPrice.visible = false

func reload_values():
	pass

func reset_values():
	pass

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

func autoclick():
	clicks += 1
	update_bar()

func update_bar():
	var new_max = ability_max - length_lower
	if new_max <= 0:
		new_max = 1
	progress_bar.max_value = new_max
	progress_bar.value = clicks
	label_min.text = str(clicks)
	label_max.text = str(new_max)
	if progress_bar.value >= progress_bar.max_value:
		SignalBus.ability_use.emit(ability_num, ability_damage + attack_bonus)
		reset_bar()

func reset_bar():
	clicks = 0
	progress_bar.value = 0
	update_bar()

func _on_button_power_pressed() -> void:
	if InfoManager.gold >= power_price:
		upgrade_power()
		InfoManager.gold -= power_price
		increase_price()

func _on_button_clicker_pressed() -> void:
	if InfoManager.gold >= clicker_price:
		upgrade_clicker()
		InfoManager.gold -= clicker_price
		increase_price()

func _on_button_length_pressed() -> void:
	if InfoManager.gold >= length_price:
		upgrade_length()
		InfoManager.gold -= length_price
		increase_price()

func increase_price():
	upgrade_price *= upgrade_scaling
	power_price = upgrade_price * randf_range(.9, 1.1)
	clicker_price = upgrade_price * randf_range(.9, 1.1)
	length_price = upgrade_price * randf_range(.9, 1.1)

func upgrade_power():
	power_level += 1
	attack_bonus += 1

func upgrade_clicker():
	clicker_level += 1
	add_autoclicker()

var autoclicker_scene : PackedScene = preload("res://autoclicker/autoclicker.tscn")
func add_autoclicker():
	var new_autoclicker : Autoclicker = autoclicker_scene.instantiate()
	new_autoclicker.starting_point = progress_bar.global_position
	new_autoclicker.ending_point = Vector2(progress_bar.global_position.x + progress_bar.custom_minimum_size.x, progress_bar.global_position.y)
	new_autoclicker.parent_ability = self
	autoclicker_hub.add_child(new_autoclicker)
	new_autoclicker.global_position = progress_bar.global_position

func upgrade_length():
	length_level += 1
	length_lower += 1
	update_bar()
