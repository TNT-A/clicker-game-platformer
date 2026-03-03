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
	preload("res://clicker_panel/resources/resource_folder/ability1.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability2.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability3.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability4.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability5.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability6.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability7.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability8.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability9.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability10.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability11.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability12.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability13.tres"),
	preload("res://clicker_panel/resources/resource_folder/ability14.tres"),
]

func _ready() -> void:
	SignalBus.register_panel.emit(self)
	SignalBus.player_health_change.connect(set_health)
	SignalBus.floor_ended.connect(save_panel)
	reload_panel()
	set_health()
	selected_panel = 0
	update_all()

func is_dragging():
	var is_dragging : bool = false
	for panel in panels:
		if panel.dragged == true:
			is_dragging = true
	return is_dragging

func check_swap():
	var swap : bool = false
	var num_hovered : int = 0
	var panel1 : AbilityPanel = null
	var panel2 : AbilityPanel = null
	for panel in panels:
		if panel.hovered == true:
			num_hovered += 1
			if panel1 == null:
				panel1 = panel 
			elif panel2 == null:
				panel2 = panel 
	print(num_hovered," ", panel1, " ",panel2)
	if num_hovered >= 2:
		swap_ability(panel1.slot_num, panel2.slot_num)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		#panel_clicks[selected_panel] += 1
		panels[selected_panel].click()
	if event.is_action_released("Click"):
		check_swap()
		print("checked swap")
		#print("You've clicked: ", panels[selected_panel], " And you've clicked: ", panel_clicks[selected_panel])
	if !is_dragging():
		if event.is_action_pressed("Scroll_Up"):
			selected_panel -= 1
			check_selected_panel("sub")
		if event.is_action_pressed("Scroll_Down"):
			selected_panel += 1
			check_selected_panel("add")
	if event.is_action_pressed("Toggle_Panel"):
		toggle_panel()
	
	if event.is_action_pressed("Num_1"):
		get_ability(0, 11, 0)
	if event.is_action_pressed("Num_2"):
		get_ability(1, 13, 0)
	if event.is_action_pressed("Num_3"):
		get_ability(2, 7, 0)
	if event.is_action_pressed("Num_4"):
		get_random_ability(3, 0)
	if event.is_action_pressed("Num_5"):
		get_random_ability(4, 0)
	if event.is_action_pressed("Num_6"):
		get_random_ability(5, 0)
	if event.is_action_pressed("ui_accept"):
		swap_ability(0,1)
	
	update_all()

func toggle_panel():
	var tween = get_tree().create_tween()
	if toggle_visible:
		tween.parallel().tween_property($PanelContainer, "position", Vector2(-130, 0), .2)
		for panel in panels:
			tween.parallel().tween_property(panel.mini_panel, "position", Vector2(136, 0), .2)
		toggle_visible = false
	else:
		tween.parallel().tween_property($PanelContainer, "position", Vector2(0, 0), .2)
		for panel in panels:
			tween.parallel().tween_property(panel.mini_panel, "position", Vector2(-40, 0), .2)
		toggle_visible = true
	tween.play()

func check_selected_panel(type : String):
	for panel in panels:
		panel.slot_pos = Vector2(0,0)
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
			"length_level" = panel.length_level,
			"rarity" = panel.rarity
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
			var r = panel["rarity"]
			set_ability(target_panel, panel)
			#print("Set ability :D")

func set_ability(panel: AbilityPanel, details: Dictionary):
	panel.ability_type = ability_list[details["ability_type"]]#ability_list[ability_num]
	panel.damage_level = details["damage_level"]
	panel.power_level = details["power_level"]
	panel.clicker_level = details["clicker_level"]
	panel.length_level = details["length_level"]
	panel.rarity = details["rarity"]
	panel_active[panels.find(panel)] = true
	panel.set_self()

func get_ability(slot:int, ability_num : int, rarity : int):
	var current_panel = panels[slot]
	panel_active[slot] = true
	current_panel.ability_type = ability_list[ability_num]
	current_panel.reset_self()
	current_panel.set_self()

func get_random_ability(slot:int, rarity:int):
	var current_panel = panels[slot]
	panel_active[slot] = true
	current_panel.ability_type = ability_list.pick_random()
	current_panel.reset_self()
	current_panel.set_self()

func swap_ability(slot1:int, slot2:int):
	var panel1 : AbilityPanel = panels[slot1]
	var panel2 : AbilityPanel = panels[slot2]
	panel1.go_home()
	panel2.go_home()
	#panel1.swapping = true
	#panel1.swapping = true
	var pos1 = panel1.global_position
	var pos2 = panel2.global_position
	var panel1_info : Dictionary = {
		"ability_type" = ability_list.find(panel1.ability_type),
		"active" = panel1.active,
		"slot" = panel1.slot_num,
		"damage_level" = panel1.damage_level,
		"power_level" = panel1.power_level,
		"clicker_level" = panel1.clicker_level,
		"length_level" = panel1.length_level,
		"rarity" = panel1.rarity
		}
	var panel2_info : Dictionary = {
		"ability_type" = ability_list.find(panel2.ability_type),
		"active" = panel2.active,
		"slot" = panel2.slot_num,
		"damage_level" = panel2.damage_level,
		"power_level" = panel2.power_level,
		"clicker_level" = panel2.clicker_level,
		"length_level" = panel2.length_level,
		"rarity" = panel2.rarity
		}
	set_ability(panel1, panel2_info)
	set_ability(panel2, panel1_info)
	
