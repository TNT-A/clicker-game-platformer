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
		property_list_changed.emit()

func get_shot_type() -> String:
	return shot_list_info[shot_type]

@export var shot_num : int = 1
@export var cone_degree : int = 1
@export var shot_delay : float = 0.0
@export var reverse_burst : float = 0.0

const all_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
	&"shot_delay",
	&"reverse_burst",
]

const single_shot_vars : Array[StringName] = []

const spread_shot_vars : Array[StringName] = [
	&"shot_num",
	&"cone_degree",
]

const surround_shot_vars : Array[StringName] = [
	&"shot_num",
]

#func _validate_property(property: Dictionary) -> void:
	#if property.name in all_shot_vars:
		#if shot_type:
			#property.usage |= PROPERTY_USAGE_EDITOR
		#else:
			#property.usage &= ~PROPERTY_USAGE_EDITOR
	#
	#if property.name in single_shot_vars:
		#if shot_type == ShotTypeList.SINGLE_SHOT:
			#property.usage |= PROPERTY_USAGE_EDITOR
		#else:
			#property.usage &= ~PROPERTY_USAGE_EDITOR
	#if property.name in spread_shot_vars:
		#if shot_type == ShotTypeList.SPREAD_SHOT:
			#property.usage |= PROPERTY_USAGE_EDITOR
		#else:
			#property.usage &= ~PROPERTY_USAGE_EDITOR
	#if property.name in surround_shot_vars:
		#if shot_type == ShotTypeList.SURROUND_SHOT:
			#property.usage |= PROPERTY_USAGE_EDITOR
		#else:
			#property.usage &= ~PROPERTY_USAGE_EDITOR
