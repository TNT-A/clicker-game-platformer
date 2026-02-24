extends Control
class_name AbilityPanel

@export var slot_num : int = 0

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

var default_size : Vector2 = Vector2(92, 24)
var expand_size : Vector2 = Vector2(92, 42)

var damage_level : int = 0
var power_level : int = 0
var clicker_level : int = 0
var length_level : int = 0

var damage_bonus : float = 0
var power_bonus : float = 0
var autoclick_power_bonus : float = 0
var length_lower : int = 0

var clicks : int = 0

var active : bool = false
var selected : bool = false

func _ready() -> void:
	#await InfoManager.clicker_panel
	SignalBus.update_selected.connect(update)
	update()
	
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max
		ability_num = ability_type.ability_num
		ability_damage = ability_type.ability_damage
	
	label.text = ability_name
	progress_bar.max_value = ability_max
	update_bar()

func _physics_process(delta: float) -> void:
	pass

func reset_values():
	pass

func update():
	if active:
		$VBoxContainer.visible = true
		$BasePanel.visible = true
	else: 
		$VBoxContainer.visible = false
		$BasePanel.visible = false
		$ExpandPanel.visible = false
	if selected:
		$BasePanel.visible = false
		$ExpandPanel.visible = true
		custom_minimum_size = expand_size
	else:
		$BasePanel.visible = true
		$ExpandPanel.visible = false
		custom_minimum_size = default_size

func click():
	clicks += InfoManager.click_power * (1 + power_bonus)
	update_bar()

func autoclick():
	clicks += InfoManager.autoclick_power * (1 + autoclick_power_bonus)
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
		SignalBus.ability_use.emit(ability_num, ability_damage + damage_bonus)
		reset_bar()

func reset_bar():
	clicks = 0
	progress_bar.value = 0
	update_bar()

func upgrade_damage():
	damage_level += 1
	damage_bonus += 1

func upgrade_power():
	power_level += 1
	power_bonus += 0.25
	autoclick_power_bonus += 0.1

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

func set_self():
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max
		ability_num = ability_type.ability_num
		ability_damage = ability_type.ability_damage
	label.text = ability_name
	progress_bar.max_value = ability_max
	load_levels()
	update_bar()

func load_levels():
	damage_bonus = damage_level
	power_bonus = power_level * .25
	autoclick_power_bonus = power_level * .1
	length_lower = length_level
	for i in range(clicker_level):
		add_autoclicker()
	update_bar()
