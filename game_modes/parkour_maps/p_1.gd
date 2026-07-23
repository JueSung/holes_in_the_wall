extends Node2D


func player_setup_information(devices, colors):
	$Player.set_device_num(devices[0]) # handles setting input set
	$Player.set_color(colors[devices[0]])

func _ready() -> void:
	$Player/Hurtbox.connect("body_entered", body_entered)
	$Player.set_physics_process(true)
	$Player.set_process(true)




func body_entered(body):
	if body is CustomObject && body.dangerous:
		print("DIE")
