extends Resource
class_name ProjectileResource

#Could be cool to add the ability for a  projectile to be made FULLY from scratch (Aka, add sprite, hitbox shape/size, etc), but that'll add a lot of extra complexity, so if we want to do that just save it for later

@export var projectile_scene : PackedScene
@export_group("Custom Scene")
@export var hurt_enemy : bool = false
@export var hurt_player : bool = false
@export var projectile_sprite :  Texture

@export_category("Projectile Stats")
##Set the projectile's speed
@export var projectile_speed : float = 100
##Set the projectile's damage
@export var projectile_damage : float = 1

@export_category("Projectile Properties")
##Not working yet
@export var is_pierce : bool = false
##Not working
@export var is_explosive : bool = false
##Not working
@export var is_bouncy : bool = false
