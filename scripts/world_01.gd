extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")

@onready var camera := $Camera2D as Camera2D
@onready var control = $HUD/Control
@onready var initial_position = $InitialPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.initial_position = initial_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)
	control.time_is_up.connect(game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	Globals.respawn_player()
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
