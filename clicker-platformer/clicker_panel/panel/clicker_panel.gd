extends Control

var toggle_visible : bool = true

var total_clicks : int = 0
var selected_panel: int = 0

@onready var panels : Array[AbilityPanel] = [
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel1,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel2,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel3,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel4,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel5,
	$PanelContainer/VBoxContainer/VBoxContainer/AbilityPanel6,
]

@onready var panel_clicks : Array = [
	0,
	0,
	0,
	0,
	0,
	0,
]

var panel_active : Array = [
	false,
	false,
	false,
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
	SignalBus.floor_ended.connect(save_panel)
	reload_panel()
	set_health()
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
	
	if event.is_action_pressed("Toggle_Panel"):
		toggle_panel()
	
	update_all()

func toggle_panel():
	var tween = get_tree().create_tween()
	if toggle_visible:
		tween.tween_property($PanelContainer, "position", Vector2(-130, 0), .3)
		toggle_visible = false
	else:
		tween.tween_property($PanelContainer, "position", Vector2(0, 0), .3)
		toggle_visible = true
	tween.play()

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

func count_active():
	var active_panels : int = 0
	for panel in panel_active:
		if panel:
			active_panels += 1
	return active_panels

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

#{ability type, active, slot, damage level, power level, clicker_level, length_level}
func save_panel():
	InfoManager.saved_panel.clear()
	for panel in panels:
		var panel_info : Dictionary = {
			"ability_type" = ability_list.find(panel.ability_type),
			"active" = panel.active,
			"slot" = panel.slot_num,
			"damage_level" = panel.damage_level,
			"power_level" = panel.power_level,
			"clicker_level" = panel.clicker_level,
			"length_level" = panel.length_level
			}
		InfoManager.saved_panel.append(panel_info)

func reload_panel():
	for panel in panel_active:
		panel = false
	for panel in InfoManager.saved_panel:
		#print("Trying")
		if panel["active"]:
			var target_panel = panels[panel["slot"]]
			var panel_ability = panel["ability_type"]
			var dl = panel["damage_level"]
			var pl = panel["power_level"]
			var cl = panel["clicker_level"]
			var ll = panel["length_level"]
			set_ability(target_panel, panel_ability, dl, pl, cl, ll)
			#print("Set ability :D")

func set_ability(panel : AbilityPanel, ability_num, dl, pl, cl, ll):
	panel.ability_type = ability_list[ability_num]
	panel.damage_level = dl
	panel.power_level = pl
	panel.clicker_level = cl
	panel.length_level = ll
	panel_active[panels.find(panel)] = true
	panel.set_self()

func ability_unlock(slot:AbilityPanel):
	var current_panel = panels.find(slot)
	panel_active[current_panel] = true
	slot.ability_type = ability_list.pick_random()
	slot.set_self()
