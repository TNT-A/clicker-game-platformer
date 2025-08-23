extends Projectile

func _on_bounce_timer_timeout() -> void:
	can_bounce = true
