extends Node2D

func _ready() -> void:
	if $AbilityPickup.ability_resource.rarity == 0:
		$Paywall.cost *= 1
	if $AbilityPickup.ability_resource.rarity == 1:
		$Paywall.cost *= 1.25
	if $AbilityPickup.ability_resource.rarity == 2:
		$Paywall.cost *= 1.5
	if $AbilityPickup.ability_resource.rarity == 3:
		$Paywall.cost *= 1.75
	if $AbilityPickup.ability_resource.rarity == 4:
		$Paywall.cost *= 2
	$Paywall.set_label()
