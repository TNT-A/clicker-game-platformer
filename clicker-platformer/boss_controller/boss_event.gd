extends Resource
class_name BossEvent

@export var packed_phase_list : Array[PackedScene]
var phase_list : Array[BossPhase]

func start_event():
	for phase in packed_phase_list:
		var new_phase : BossPhase = phase.instantiate()
