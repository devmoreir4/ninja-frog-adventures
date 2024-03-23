extends Area2D

@onready var collision = $Collision as CollisionShape2D
@onready var spikes = $Spikes as Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = spikes.get_rect().size # preenche auto o tamanho dos spikes

func _on_body_entered(body):
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
