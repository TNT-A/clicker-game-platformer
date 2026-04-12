extends Control
class_name AbilityPanel

@export var slot_num : int = 0
var slot_pos : Vector2 = Vector2(0,0)

@onready var label_name: Label = $VBoxContainer/HBoxContainer2/LabelName
@onready var progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBar
@onready var progress_bar_alt: ProgressBar = $MiniPanel/CenterContainer/ProgressBarAlt
@onready var label_clicksleft: Label = $ExpandPanel/ExpandDetails/LabelClicksleft
@onready var check_box_autolaunch: CheckBox = $ExpandPanel/ExpandDetails/HBoxVclickables/CheckBoxAutolaunch
@onready var mini_panel: Panel = $MiniPanel

@onready var autoclicker_hub: Node2D = $AutoclickerHub

@export var ability_type : AbilityResource

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
		
		power_level = ability_type.power_level
		damage_level = ability_type.damage_level
		clicker_level = ability_type.clicker_level
		length_level = ability_type.length_level
	label_name.text = ability_name
	progress_bar.max_value = ability_max
	update_bar()

func _process(delta: float) -> void:
	pass

func update():
	if active:
		$VBoxContainer.visible = true 
		$BasePanel.visible = true
		$MiniPanel/BasePanelSmall.visible = true
		$MiniPanel/ExpandedPanelSmall.visible = true
	else: 
		$VBoxContainer.visible = false
		$BasePanel.visible = false
		$ExpandPanel.visible = false
		$MiniPanel/BasePanelSmall.visible = false
		$MiniPanel/ExpandedPanelSmall.visible = false
	if selected:
		$BasePanel.visible = false
		$ExpandPanel.visible = true
		$MiniPanel/BasePanelSmall.visible = false
		$MiniPanel/ExpandedPanelSmall.visible = true
		progress_bar_alt.custom_minimum_size = Vector2(30, 56)
		custom_minimum_size = expand_size
	else:
		$BasePanel.visible = true
		$ExpandPanel.visible = false
		$MiniPanel/BasePanelSmall.visible = true
		$MiniPanel/ExpandedPanelSmall.visible = false
		progress_bar_alt.custom_minimum_size = Vector2(30, 30)
		if !active:
			$BasePanel.visible = false
			$ExpandPanel.visible = false
			$MiniPanel/BasePanelSmall.visible = false
			$MiniPanel/ExpandedPanelSmall.visible = false
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
	
	progress_bar_alt.max_value = new_max
	progress_bar_alt.value = clicks
	
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
	clicks = 0
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
