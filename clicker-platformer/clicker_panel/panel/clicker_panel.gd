extends Control
class_name ClickerPanel

var toggle_visible : bool = true

var total_clicks : int = 0
var selected_panel: int = 0

@onready var new_ability_drag_zone: DragZone = $PanelContainer/VBoxContainer/VBoxContainer/NewAbilityDragZone
@onready var new_ability_drag_zone_og_pos : Vector2 = new_ability_drag_zone.position

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
	SignalBus.forward_to_host.connect(accept_resource)
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		#panel_clicks[selected_panel] += 1
		panels[selected_panel].click()
	if !is_dragging():
		if event.is_action_pressed("Scroll_Up"):
			selected_panel -= 1
			check_selected_panel("sub")
		if event.is_action_pressed("Scroll_Down") or event.is_action_pressed("Shift"):
			selected_panel += 1
			check_selected_panel("add")
		
		if event.is_action_pressed("Num_1"):
			selected_panel = 0
			check_selected_panel("add")
		if event.is_action_pressed("Num_2"):
			selected_panel = 1
			check_selected_panel("add")
		if event.is_action_pressed("Num_3"):
			selected_panel = 2
			check_selected_panel("add")
		if event.is_action_pressed("Num_4"):
			selected_panel = 3
			check_selected_panel("add")
		if event.is_action_pressed("Num_5"):
			selected_panel = 4
			check_selected_panel("add")
		if event.is_action_pressed("Num_6"):
			selected_panel = 5
			check_selected_panel("add")
		
	if event.is_action_pressed("Toggle_Panel"):
		#toggle_panel()
		pass
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

func find_inactive():
	var closest_inactive : int = 0
	for active in panel_active:
		if active:
			closest_inactive += 1
	if closest_inactive == panel_active.size():
		closest_inactive = -1
	return closest_inactive

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
	set_new_ability_zone_pos()

#{ability type, active, slot, damage level, power level, clicker_level, length_level}
func save_panel():
	InfoManager.saved_panel.clear()
	for panel in panels:
		if !panel.active:
			InfoManager.saved_panel.append(false)
		else:
			var panel_info : AbilityResource = AbilityResource.new()
			panel_info.ability_num = panel.ability_num
			panel_info.ability_name = panel.ability_name
			panel_info.ability_damage = panel.ability_damage
			panel_info.ability_max = panel.ability_max
			panel_info.damage_level = panel.damage_level
			panel_info.power_level = panel.power_level
			panel_info.clicker_level = panel.clicker_level
			panel_info.length_level = panel.length_level
			panel_info.rarity = panel.rarity
			InfoManager.saved_panel.append(panel_info)

func reload_panel():
	for panel in panel_active:
		panel = false
	for panel in panels:
		panel.ability_type = null
		panel.active = false
	
	var slot_num : int = 0
	for panel in InfoManager.saved_panel:
		if panel is AbilityResource:
			var target_panel = panels[slot_num]
			set_ability(target_panel, panel)
		slot_num += 1

func set_ability(panel: AbilityPanel, ability_resource : AbilityResource):
	panel.ability_type = ability_resource
	panel_active[panels.find(panel)] = true
	panel.set_self()

#ability_num version
func test_get_ability(slot:int, ability_num : int, rarity : int):
	var current_panel = panels[slot]
	panel_active[slot] = true
	current_panel.ability_type = ability_list[ability_num]
	current_panel.reset_self()
	current_panel.set_self()

#ability resource version
func get_ability(slot:int, ability_type:AbilityResource):
	var current_panel = panels[slot]
	panel_active[slot] = true
	current_panel.ability_type = ability_type
	current_panel.reset_self()
	current_panel.set_self()
	update_all()

func get_random_ability(slot:int, rarity:int):
	var current_panel = panels[slot]
	panel_active[slot] = true
	current_panel.ability_type = ability_list.pick_random()
	current_panel.reset_self()
	current_panel.set_self()

func set_new_ability_zone_pos():
	var num_active : int = count_active()
	var pos_change : Vector2 = Vector2(0, (num_active - 1) * AbilityPanel.default_size.y + AbilityPanel.expand_size.y + (10 * num_active))
	if num_active == panels.size():
		pos_change.y = 1000
	new_ability_drag_zone.position = new_ability_drag_zone_og_pos + pos_change

func accept_resource(host : Node, drag_info : Resource, draggable : Draggable):
	if self == host:
		var open_num : int = find_inactive()
		if draggable.host is AbilityPickup and open_num != -1:
			get_ability(open_num, drag_info)

#Deprecated :(
func swap_ability(slot1:int, slot2:int):
	pass
	#var panel1 : AbilityPanel = panels[slot1]
	#var panel2 : AbilityPanel = panels[slot2]
	#panel1.go_home()
	#panel2.go_home()
	##panel1.swapping = true
	##panel1.swapping = true
	#var pos1 = panel1.global_position
	#var pos2 = panel2.global_position
	#var panel1_info : Dictionary = {
		#"ability_type" = ability_list.find(panel1.ability_type),
		#"active" = panel1.active,
		#"slot" = panel1.slot_num,
		#"damage_level" = panel1.damage_level,
		#"power_level" = panel1.power_level,
		#"clicker_level" = panel1.clicker_level,
		#"length_level" = panel1.length_level,
		#"rarity" = panel1.rarity
		#}
	#var panel2_info : Dictionary = {
		#"ability_type" = ability_list.find(panel2.ability_type),
		#"active" = panel2.active,
		#"slot" = panel2.slot_num,
		#"damage_level" = panel2.damage_level,
		#"power_level" = panel2.power_level,
		#"clicker_level" = panel2.clicker_level,
		#"length_level" = panel2.length_level,
		#"rarity" = panel2.rarity
		#}
	#set_ability(panel1, panel2_info)
	#set_ability(panel2, panel1_info)
	
