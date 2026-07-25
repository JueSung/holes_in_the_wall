extends Node2D
class_name FreePlay

var map = null

var players = []

var devices := []
var colors := {}

func player_setup_information(devices_, colors_):
	devices = devices_.duplicate()
	colors = colors_.duplicate()
	

func _ready() -> void:
	$GameHUD.visible = false

func start() -> void:
	var chosen_map = $HUD/MapSelection.get_chosen_map()
	if chosen_map == "":
		$HUD/Label.text = "Choose Map"
		return
	
	
	$HUD.visible = false
	$GameHUD.visible = true
	
	for i in range(len(devices)):
		var player = preload("res://player.tscn").instantiate()
		players.append(player)
		add_child(player)
		player.set_device_num(devices[i])
		player.set_color(colors[devices[i]])
		player.global_position = Vector2(1920 * (i+1.)/(len(devices)+1), 800)
		player.set_physics_process(true)
		player.set_process(true)


	# set up map after players so if map needs players, can grab using get_players() and to set player positions if needed
	map = load(chosen_map).instantiate()
	add_child(map)

func get_players():
	return players


func back():
	$GameHUD.visible = false
	$HUD.visible = true
	if is_instance_valid(map):
		map.queue_free()
	map = null

	for i in range(len(players)):
		if is_instance_valid(players[i]):
			players[i].queue_free()
	players = []

func back_to_main() -> void:
	get_parent().back()
