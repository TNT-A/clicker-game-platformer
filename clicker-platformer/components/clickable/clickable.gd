extends Area2D
class_name Clickable

@export var clicks_needed : int = 1

var hovered : bool = false

var current_clicks : int = 0

##Triggered whenever the clickable area is clicked
signal clickable_clicked

##Triggered whenever the clickable reaches it's needed clicks
signal clickable_used

##Triggers whenever the clickable is hovered
signal clickable_hovered

func click():
	current_clicks += 1
	clickable_clicked.emit()
	if current_clicks >= clicks_needed:
		use()

func use():
	clickable_used.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and hovered:
		click()

func _on_mouse_entered() -> void:
	hovered = true
	clickable_hovered.emit()

func _on_mouse_exited() -> void:
	hovered = false
