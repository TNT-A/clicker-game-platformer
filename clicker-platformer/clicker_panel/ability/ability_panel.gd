extends Control
class_name AbilityPanel

@export var slot_num : int = 0
var slot_pos : Vector2 = Vector2(0,0)

@onready var label_name: Label = $VBoxContainer/HBoxContainer2/LabelName
@onready var progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBar
@onready var label_clicksleft: Label = $ExpandPanel/ExpandDetails/LabelClicksleft
@onready var check_box_autolaunch: CheckBox = $ExpandPanel/ExpandDetails/HBoxVclickables/CheckBoxAutolaunch

@onready var autoclicker_hub: Node2D = $AutoclickerHub

@export var ability_type : Resource

@export var rarity : int = 0

var ability_name : String = "base"
var ability_max : int = 10
var ability_num : int = 1
var ability_damage : float = 1

var default_size : Vector2 = Vector2(92, 22)
var expand_size : Vector2 = Vector2(92, 46)

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
var hovered : bool = false
var dragged : bool = false
var home : bool = true
var swapping : bool = false
var ability_ready : bool = false

var home_lerp : float  = .3

func _ready() -> void:
	SignalBus.update_selected.connect(update)
	#SignalBus.ability_change.connect(reset_self)
	update()
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max
		ability_num = ability_type.ability_num
		ability_damage = ability_type.ability_damage
	label_name.text = ability_name
	progress_bar.max_value = ability_max
	update_bar()

func _process(delta: float) -> void:
	if dragged:
		#print("dragger")
		z_index = 1
		home = false
		global_position = get_global_mouse_position() - Vector2(custom_minimum_size.x/2, custom_minimum_size.y/2)
		hovered = true
		$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif slot_pos != Vector2(0,0) and global_position != slot_pos:
		$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#print("yahoo")
		z_index = 0
		global_position = global_position.lerp(slot_pos, home_lerp)
	if global_position.distance_to(slot_pos) < 3 and !home and !dragged and !swapping:
		$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_PASS
		$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_PASS
		global_position = slot_pos
		home = true
		hovered = false

func set_slot_pos():
	slot_pos = global_position

func go_home():
	if slot_pos != Vector2(0, 0):
		global_position = slot_pos

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and hovered and home:
		slot_pos = global_position
		dragged = true
	if event.is_action_released("Click"):
		dragged = false

func update():
	if active:
		$VBoxContainer.visible = true 
		$BasePanel.visible = true
	else: 
		$VBoxContainer.visible = false
		$BasePanel.visible = false
		$ExpandPanel.visible = false
		$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if selected:
		$BasePanel.visible = false
		$ExpandPanel.visible = true
		$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_PASS
		custom_minimum_size = expand_size
	else:
		$BasePanel.visible = true
		$ExpandPanel.visible = false
		if active:
			$HoverHub/Collapsed.mouse_filter = Control.MOUSE_FILTER_PASS
			$HoverHub/Expanded.mouse_filter = Control.MOUSE_FILTER_IGNORE
		custom_minimum_size = default_size

func click():
	if !ability_ready:
		clicks += InfoManager.click_power * (1 + power_bonus)
	else:
		use_ability()
	update_bar()

func autoclick():
	if !ability_ready:
		clicks += InfoManager.autoclick_power * (1 + autoclick_power_bonus)
	update_bar()

func update_bar():
	var new_max = ability_max - length_lower
	var clicks_left = new_max-clicks
	if new_max <= 0:
		new_max = 1
	if clicks_left <= 0:
		clicks_left = 0
	progress_bar.max_value = new_max
	progress_bar.value = clicks
	label_clicksleft.text = "Est. Clicks Left: " + str(clicks_left)
	#label_min.text = str(clicks)
	#label_max.text = str(new_max)
	if progress_bar.value >= progress_bar.max_value:
		if check_box_autolaunch.button_pressed:
			use_ability()
		else: 
			ability_ready = true


func use_ability():
		SignalBus.ability_use.emit(ability_num, ability_damage + damage_bonus)
		ability_ready = false
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

func reset_self():
	damage_level = 0
	power_level = 0
	length_level = 0
	clicker_level = 0
	load_levels()

func set_self():
	if is_instance_valid(ability_type):
		ability_name = ability_type.ability_name
		ability_max = ability_type.ability_max
		ability_num = ability_type.ability_num
		ability_damage = ability_type.ability_damage
		rarity = ability_type.rarity
	label_name.text = ability_name
	progress_bar.max_value = ability_max
	load_levels()
	update_bar()

func load_levels():
	damage_bonus = damage_level
	power_bonus = power_level * .25
	autoclick_power_bonus = power_level * .1
	length_lower = length_level
	clear_autoclicker()
	for i in range(clicker_level):
		add_autoclicker()
	update_bar()

func clear_autoclicker():
	for child in $AutoclickerHub.get_children():
		child.queue_free()

func _on_collapsed_mouse_entered() -> void:
	#print("Hovering ", slot_num)
	hovered = true

func _on_collapsed_mouse_exited() -> void:
	#print("Stopped hovering ", slot_num)
	#if !Input.is_action_pressed("Click"):
		#hovered = false
	hovered = false 

func _on_expanded_mouse_entered() -> void:
	#print("Hovering ", slot_num)
	hovered = true

func _on_expanded_mouse_exited() -> void:
	#print("Stopped hovering ", slot_num)
	#if !Input.is_action_pressed("Click"):
		#hovered = false
	hovered = false 
