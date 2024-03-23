extends Node2D

@onready var texture = $Texture
@onready var area_sign = $AreaSign

const lines : Array[String] = [
	"Hello World!",
	"It's great to see you here",
	"I hope you are ready for the challenges",
	"Good luck!"
]

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			texture.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
