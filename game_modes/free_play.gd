extends Node2D
class_name FreePlay

var map = null


func player_setup_information(devices, colors):
	print(colors)
	$Player.set_device_num(devices[0]) # handles setting input set
	$Player.set_color(colors[devices[0]])

func _ready() -> void:
	$Player.set_physics_process(false)
	$Player.set_process(false)
	$Player.visible = true
	$GameHUD.visible = false

func start() -> void:
	var chosen_map = $HUD/MapSelection.get_chosen_map()
	if chosen_map == "":
		$HUD/Label.text = "Choose Map"
		return
	
	map = load(chosen_map).instantiate()
	add_child(map)
	$HUD.visible = false
	$GameHUD.visible = true
	$Player.global_position = Vector2(1920/2., 800)
	$Player.set_physics_process(true)
	$Player.set_process(true)
	$Player.visible = true



func back():
	$GameHUD.visible = false
	$HUD.visible = true
	$Player.set_physics_process(false)
	$Player.set_process(false)
	$Player.visible = false
	if is_instance_valid(map):
		map.queue_free()
	map = null

func back_to_main() -> void:
	get_parent().back()
