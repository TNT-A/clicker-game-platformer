extends Control

var total_clicks : int = 0
var selected_panel: int = 0

@onready var panels : Array = [
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel1,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel2,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel3,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel4,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel5,
]

@onready var panel_clicks : Array = [
	0,
	0,
	0,
	0,
	0
]

var panel_active : Array = [
	true,
	true,
	false,
	false,
	false,
]

var ability_list : Array = [
	preload("res://clicker_panel/resources/resource_folder/a1.tres"),
	preload("res://clicker_panel/resources/resource_folder/a2.tres"),
	preload("res://clicker_panel/resources/resource_folder/a3.tres"),
	preload("res://clicker_panel/resources/resource_folder/a4.tres"),
	preload("res://clicker_panel/resources/resource_folder/a5.tres"),
	preload("res://clicker_panel/resources/resource_folder/a6.tres"),
	preload("res://clicker_panel/resources/resource_folder/a7.tres"),
	preload("res://clicker_panel/resources/resource_folder/a8.tres"),
	preload("res://clicker_panel/resources/resource_folder/a9.tres"),
	preload("res://clicker_panel/resources/resource_folder/a10.tres"),
	preload("res://clicker_panel/resources/resource_folder/a11.tres"),
	preload("res://clicker_panel/resources/resource_folder/a12.tres"),
	preload("res://clicker_panel/resources/resource_folder/a13.tres"),
	preload("res://clicker_panel/resources/resource_folder/a14.tres"),
]

func _ready() -> void:
	SignalBus.register_panel.emit(self)
	SignalBus.player_health_change.connect(set_health)
	SignalBus.ability_unlock.connect(ability_unlock)
	set_health()
	selected_panel = 0
	update_all()

func ability_unlock(slot:AbilityPanel):
	var current_panel = panels.find(slot)
	panel_active[current_panel] = true
	slot.ability_type = ability_list.pick_random()
	slot.set_self()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		#panel_clicks[selected_panel] += 1
		panels[selected_panel].click()
		#print("You've clicked: ", panels[selected_panel], " And you've clicked: ", panel_clicks[selected_panel])
	
	if event.is_action_pressed("Scroll_Up"):
		selected_panel -= 1
		check_selected_panel("sub")
	
	if event.is_action_pressed("Scroll_Down"):
		selected_panel += 1
		check_selected_panel("add")
	
	update_all()

func check_selected_panel(type : String):
		if selected_panel > len(panels) - 1:
			selected_panel = 0
		if selected_panel < 0:
			selected_panel = len(panels) - 1
		if !panel_active[selected_panel]:
			if type == "add":
				selected_panel += 1
			if type == "sub":
				selected_panel -= 1
			check_selected_panel(type)

func set_active():
	for panel in panels:
		if panel_active[panels.find(panel)]:
			panel.active = true
		else:
			panel.active = false

func set_selected():
	for panel in panels:
		if panels.find(panel) == selected_panel:
			panel.selected = true
		else:
			panel.selected = false

func set_health():
	$PanelContainer/CenterContainer/HealthBar.max_value = InfoManager.player.max_health
	$PanelContainer/CenterContainer/HealthBar.value = InfoManager.player.health
	$PanelContainer/CenterContainer/HealthLabel.text = str(InfoManager.player.health) + "/" +str(InfoManager.player.max_health)

func update_all():
	set_active()
	set_selected()
	SignalBus.update_selected.emit()
