extends Control

@onready var label: Label = $PanelContainer/VBoxContainer/Label
@onready var progress_bar: ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer/ProgressBar

var ability_type : String = "base"
var ability_max : int = 10
var ability_num : int = 1

var clicks : int = 0

var active : bool = false
var selected : bool = false

func _ready() -> void:
	await InfoManager.clicker_panel
	SignalBus.update_selected.connect(update)
	label.text = ability_type
	progress_bar.max_value = ability_max

func update():
	if active:
		visible = true
	else: 
		visible = false
	
	if selected:
		scale = Vector2(1.2, 1.2)
	else:
		scale = Vector2(1, 1)

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
