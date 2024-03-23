extends CharacterBody2D

var move_speed := 150.0
var direction := 1

func _process(delta):
	position.x += move_speed * direction * delta
	
func set_direction(dir):
	direction = dir
	if dir < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
