extends EnemyBase

func _ready():
	wall_detector = $WallDetector
	texture = $Texture
	anim.animation_finished.connect(kill_ground_enemy)
	
func _physics_process(delta):
	_aplly_gravity(delta)
	movement(delta)
	flip_direction()
	
