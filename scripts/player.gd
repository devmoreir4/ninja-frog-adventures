extends CharacterBody2D

const SPEED = 200.0
const AIR_FRICTION = 1.2

var is_jumping := false
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20
var direction

# handle jump and gravity
@export var jump_height := 160
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity
var fall_gravity

signal player_has_died()

@onready var animation := $Animation as AnimatedSprite2D
@onready var remote_transform := $Remote as RemoteTransform2D
@onready var jump_sfx = $JumpSFX as AudioStreamPlayer

func  _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.x = 0
		#velocity.y += gravity * delta

	#Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
	
	if velocity.y > 0 or not Input.is_action_just_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta

	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	print(knockback)
	take_damage(knockback)
		
	if body.is_in_group("bullet"):
		body.queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		#parallel() executa os tweens paralelamente
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _input(event): #for the jump error on mobile
	if event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = -jump_velocity
			is_jumping = true
		elif is_on_floor():
			is_jumping= false
			
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
		
	if animation.name != state:
		animation.play(state)
