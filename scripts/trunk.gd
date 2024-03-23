extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var animation = $Animation
@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var ground_detector = $GroundDetector
@onready var player_detector = $PlayerDetector

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target : CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var BULLET = preload("res://prefabs/bullet.tscn")

var move_speed := 50.0
var direction := 1
var health_points := 3

func _ready():
	pass
	
func _physics_process(delta):
	_aplly_gravity(delta)
	
	match (current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()
		
func patrol_state():
	animation.play("running")
	if is_on_wall():
		flip_enemy()
	
	if not ground_detector.is_colliding():
		flip_enemy()
	
	velocity.x = move_speed * direction
	
	if player_detector.is_colliding():
		change_state(EnemyState.ATTACK)
	
	move_and_slide()

func attack_state():
	animation.play("shooting")
	if not player_detector.is_colliding():
		change_state(EnemyState.PATROL)

func hurt_state():
	animation.play("hurt")
	await get_tree().create_timer(0.3).timeout
	change_state(EnemyState.PATROL)
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()

func change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	bullet_spawn_point.position.x *= -1

func spawn_bullet():
	var new_bullet = BULLET.instantiate()
	if sign(bullet_spawn_point.position.x) == 1:
		new_bullet.set_direction(1)
	else:
		new_bullet.set_direction(-1)
		
	add_sibling(new_bullet)
	new_bullet.global_position = bullet_spawn_point.global_position

func _aplly_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_hitbox_body_entered(body):
	change_state(EnemyState.HURT)
	hurt_state()
