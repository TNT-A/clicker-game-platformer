extends Control
class_name PauseMenu

@onready var settings_menu: Control = $SettingsMenu
@onready var pause_ui: CenterContainer = $PauseUI

var is_opened : bool = false

func _ready() -> void:
	visible = false
	settings_menu.visible = false

func open_menu():
	is_opened = true
	visible = true
	Engine.time_scale = 0

func close_menu():
	close_settings()
	is_opened = false
	visible = false
	Engine.time_scale = 1

func open_settings():
	pause_ui.visible = false
	settings_menu.visible = true

func close_settings():
	pause_ui.visible = true
	settings_menu.visible = false

func _on_game_button_pressed() -> void:
	close_menu()

func _on_settings_button_pressed() -> void:
	open_settings()

func _on_menu_button_pressed() -> void:
	SignalBus.game_end.emit()

func _on_settings_menu_close_pause() -> void:
	close_menu()

func _on_settings_menu_close_settings() -> void:
	close_settings()
