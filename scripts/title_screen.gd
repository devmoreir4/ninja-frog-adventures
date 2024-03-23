extends Control

func _ready():
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://levels/world_01.tscn")


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
