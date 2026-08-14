@tool
extends Resource
class_name ShotDataResource

@export var projectile_type : ProjectileResource

##Num 0-360 to represent how much to offset the angle of the shot by from its intended target
@export var direction_offset : float = 0.0

enum ShotTypeList {
	SINGLE_SHOT, ##Fires a single shot
	SPREAD_SHOT, ##Fires X shots in a spread pattern with X degree
	SURROUND_SHOT, ##Fires X shots around you with an even spread
	BURST_SINGLE_SHOT, ##Fires X individual shots with X delay between them
	BURST_SPREAD_SHOT, ##Fires X shots in the spread pattern with X delay between them
	BURST_SURROUND_SHOT, ##Fires X shots in the surround pattern with X delay between them
}

var shot_list_info : Dictionary[ShotTypeList, String] = {
	ShotTypeList.SINGLE_SHOT : "single",
	ShotTypeList.SPREAD_SHOT : "spread", #Needs a number of shots, and the degree of the cone
	ShotTypeList.SURROUND_SHOT : "surround", #Needs a number of shots
	ShotTypeList.BURST_SINGLE_SHOT : "burst_single", #Needs a shot delay and shot num
	ShotTypeList.BURST_SPREAD_SHOT : "burst_spread", #Needs shot delay, num, and cone degree
	ShotTypeList.BURST_SURROUND_SHOT : "burst_surround", #Needs shot delay and num
}

##Choose a shot type!
@export var shot_type : ShotTypeList:
	set(value):
		shot_type = value
		if shot_type == ShotTypeList.SINGLE_SHOT:
			cur_shot_vars = single_shot_vars
		elif shot_type == ShotTypeList.SPREAD_SHOT:
			cur_shot_vars = spread_shot_vars
		elif shot_type == ShotTypeList.SURROUND_SHOT:
			cur_shot_vars = surround_shot_vars
		elif shot_type == ShotTypeList.BURST_SINGLE_SHOT:
			cur_shot_vars = burst_single_shot_vars
		elif shot_type == ShotTypeList.BURST_SPREAD_SHOT:
			cur_shot_vars = burst_spread_shot_vars
		elif shot_type == ShotTypeList.BURST_SURROUND_SHOT:
			cur_shot_vars = burst_surround_shot_vars
		print(cur_shot_vars)
		set_not_shot_vars()
		property_list_changed.emit()

func set_not_shot_vars():
	not_shot_vars.clear()
	for shot_var in all_shot_vars:
		if !cur_shot_vars.has(shot_var):
			not_shot_vars.append(shot_var)

func get_shot_type() -> String:
	return shot_list_info[shot_type]

##Number of shots fired
@export var shot_num : int = 1
##The degree of the spread shot's cone
@export var cone_degree : float = 0
##The delay betweeen each shot fired in a burst
@export var shot_delay : float = 0.0
##Should the order of the shots in the burst be reversed?
@export var reverse_burst : bool = false

const all_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
	&"shot_delay",
	&"reverse_burst",
]

var cur_shot_vars : Array[StringName] = [
	
]

var not_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
	&"shot_delay",
	&"reverse_burst",
]

const single_shot_vars : Array[StringName] = [
]

const spread_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
]

const surround_shot_vars : Array[StringName] = [
	&"shot_num",
]

const burst_single_shot_vars : Array[StringName] = [
	&"shot_num",
	&"shot_delay",
]

const  burst_spread_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
	&"shot_delay",
	&"reverse_burst",
]

const  burst_surround_shot_vars : Array[StringName] = [
	&"shot_num",
	&"shot_delay",
	&"reverse_burst",
]

func _get_property_list() -> Array[Dictionary]:
	notify_property_list_changed()
	return []

func _validate_property(property: Dictionary) -> void:
	if property.name in cur_shot_vars:
		property.usage |= PROPERTY_USAGE_EDITOR
	elif property.name in not_shot_vars:
		property.usage &= ~PROPERTY_USAGE_EDITOR
