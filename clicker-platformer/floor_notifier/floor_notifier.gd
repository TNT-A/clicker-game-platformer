extends Control
class_name FloorNotifier

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var center_container: CenterContainer = $CenterContainer
@onready var area_label: Label = $CenterContainer/VBoxContainer/AreaLabel
@onready var h_box_container: HBoxContainer = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer

func _ready() -> void:
	center_container.position.x += InfoManager.cam_pivot.x/2
	SignalBus.floor_started.connect(popup_notifier)

func setup_label():
	area_label.text = InfoManager.saved_area_resource.area_name + " #" + str(InfoManager.current_floor_num)

#Rn this just spawns placeholders and stuff, make it cool later!
func spawn_floor_markers():
	for i in InfoManager.saved_area_resource.base_floor_nums:
		var new_marker : ColorRect = ColorRect.new()
		new_marker.custom_minimum_size = Vector2(8, 8)
		h_box_container.add_child(new_marker)
		if i < InfoManager.current_floor_num:
			new_marker.self_modulate.a = 1
		else:
			new_marker.self_modulate.a = 0.3

func popup_notifier():
	setup_label()
	spawn_floor_markers()
	animation_player.play("popup")
