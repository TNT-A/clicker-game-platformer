extends Node2D

var total_clicks : int = 0
var selected_panel: int = 0

@onready var panels : Array = [
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel1,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel2,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel3,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel4,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel5
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
	true,
	true,
	true,
]

func _ready() -> void:
	SignalBus.register_panel.emit(self)
	selected_panel = 0
	update_all()

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

func update_all():
	set_active()
	set_selected()
	SignalBus.update_selected.emit()
