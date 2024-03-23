extends EnemyBase

func _physics_process(delta):
	_aplly_gravity(delta)
	movement(delta)
