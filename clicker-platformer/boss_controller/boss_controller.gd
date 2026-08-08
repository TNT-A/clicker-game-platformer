extends Node2D
class_name BossController

@onready var boss_ui: BossUI = $CanvasLayer/BossUI

@export var current_boss_event : BossEvent
var packed_phase_list : Array[PackedScene]
var phase_list : Array[BossPhase]

var current_phase : int = 0
var current_room : RoomBase
var room_pos : Vector2 = Vector2(0,0)

func _ready() -> void:
	SignalBus.boss_room_started.connect(set_event)
	SignalBus.phase_end.connect(advance_phase)

func set_event(room : RoomBase):
	#print("BOSS ROOM STARTED!!!!")
	clear_event()
	current_room = room
	room_pos = room.global_position
	current_boss_event = room.boss_event
	packed_phase_list = current_boss_event.packed_phase_list
	start_event()

func clear_event():
	for phase in phase_list:
		if is_instance_valid(phase):
			phase.queue_free()
	phase_list.clear()
	packed_phase_list.clear()
	current_phase = 0

func start_event():
	var cur_phase_num : int = 0
	if packed_phase_list:
		for phase in packed_phase_list:
			var new_phase : BossPhase = phase.instantiate()
			new_phase.phase_num = cur_phase_num
			phase_list.append(new_phase)
			cur_phase_num += 1
	start_phase(0)

func end_event():
	boss_ui.end_boss()
	SignalBus.room_ended.emit(current_room.room_slot, current_room)

func start_phase(phase_num : int):
	#print("The current phase is: " + str(phase_num))
	var phase = phase_list[phase_num]
	call_deferred("add_child", phase)
	call_deferred("start_phase_nodes", phase)

func start_phase_nodes(phase : BossPhase):
	phase.global_position = room_pos
	await phase.start_phase()
	boss_ui.start_boss(phase)

func clear_phase():
	for child in get_children():
		if child is BossPhase and is_instance_valid(child):
			child.queue_free()

func advance_phase(phase_num : int):
	current_phase = phase_num + 1
	#print("Phase advanced to: " + str(current_phase))
	if phase_list.size() > current_phase:
		clear_phase()
		start_phase(current_phase)
	else:
		end_event()
	#var phase = phase_list[current_phase]
	#phase.phase_num = phase_list.find(phase)
	#phase.start_phase()
