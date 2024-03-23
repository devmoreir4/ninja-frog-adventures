extends Area2D

@onready var coin_sfx = $CoinSFX as AudioStreamPlayer

var coins := 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	$Animated.play("collect")
	coin_sfx.play()
	# correção bug coleta dupla de moedas
	await $Collision.call_deferred("queue_free")
	Globals.coins += coins

func _on_animated_animation_finished():
	queue_free()
