extends Node2D
class_name Parkour


# handler of parkour maps
var map = null

var devices := []
var colors := {}

func player_setup_information(devices_, colors_):
	# we just keep these to pass on to levels
	devices = devices_.duplicate()
	colors = colors_.duplicate()

func level_selected(num: int) -> void:
	$HUD.visible = false
	if map && is_instance_valid(map):
		map.queue_free()
	map = load("res://game_modes/parkour_maps/p_" + str(num) + ".tscn").instantiate()
	map.player_setup_information(devices, colors)
	add_child(map)
	
