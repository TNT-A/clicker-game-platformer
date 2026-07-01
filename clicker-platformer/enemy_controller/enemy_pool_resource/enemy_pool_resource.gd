extends Resource
class_name EnemyPoolResource

#Has all enemy info
#region
#Enum with all available enemies
enum EnemyList {
	BETA_COOKIE, 
	BETA_L, 
	BETA_GHOST, 
	BETA_BOX, 
	BETA_UFO,
	}

#Dictionary that connects all the enum values to the scene of the enemy the represent
var enemy_list_info : Dictionary[EnemyList, PackedScene] = {
	EnemyList.BETA_COOKIE : preload("res://enemies/enemies/bounce_enemy/BounceEnemy.tscn"),
	EnemyList.BETA_L : preload("res://enemies/enemies/walker/walker_enemy.tscn"),
	EnemyList.BETA_GHOST : preload("res://enemies/enemies/follow_shoot/follow_shoot.tscn"),
	EnemyList.BETA_BOX : preload("res://enemies/enemies/bully_box/bully_box.tscn"),
	EnemyList.BETA_UFO : preload("res://enemies/enemies/ufo/ufo_enemy.tscn"),
}
#endregion

@export var elite_weight : float = 0.0

@export var pool : Dictionary[EnemyList, EnemyDataResource] = {
	
}
