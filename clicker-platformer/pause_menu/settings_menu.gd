extends Control
class_name SettingsMenu

signal close_pause
signal close_settings

func _on_game_button_pressed() -> void:
	close_pause.emit()

func _on_menu_button_pressed() -> void:
	close_settings.emit()
