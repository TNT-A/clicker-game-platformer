extends CharacterBody2D
class_name Enemy

@export var enemy_name : String = "Template"

@export var max_health : int = 3
@export var health : int = 3
@export var damage : int = 1

@export var is_boss : bool = false

@export_category("Spawn Indicator Vars")
@export var use_indicator : bool = false
@export var indicator_time : float = 1.0
@export var indicator_texture : Texture

var cur_indicator : SpawnIndicator 
@onready var indicator_scene : PackedScene = preload("res://enemies/spawn_indicator/spawn_indicator.tscn")

var gold : int = 10

func _ready() -> void:
	#print("Hi!")
	#print("Im an enemy, am I using the indicator: " + str(use_indicator))
	if use_indicator:
		#print("Using indicator!!!")
		spawn_indicator()
		freeze_enemy()
		if indicator_time >= 0:
			await get_tree().create_timer(indicator_time).timeout
			despawn_indicator()
			unfreeze_enemy()
		else:
			despawn_indicator()
			unfreeze_enemy()

func spawn_indicator():
	var new_indicator : SpawnIndicator = indicator_scene.instantiate()
	new_indicator.global_position = self.global_position
	cur_indicator = new_indicator
	get_parent().add_child(cur_indicator)

func despawn_indicator():
	if cur_indicator:
		cur_indicator.queue_free()

func freeze_enemy():
	print("Frozen")
	self.process_mode = PROCESS_MODE_DISABLED
	self.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	self.visible = false

func unfreeze_enemy():
	print("Unfrozen")
	self.process_mode = Node.PROCESS_MODE_INHERIT
	self.disable_mode = CollisionObject2D.DISABLE_MODE_KEEP_ACTIVE
	self.visible = true

func flash():
	if is_boss:
		SignalBus.boss_hit.emit()

func die():
	#print("I'm dying")
	SignalBus.enemy_killed.emit(self)
	var rand_num = randi_range(0,3)
	if rand_num == 3:
		gold = 30
	InfoManager.gold += gold
	queue_free()
