extends Node
class_name Main

var player : Player = null # set by ready

var gamemode = null

var num_players := 0
var devices := [-1] # device numbers, numbering schemed described in player_settings
var colors := {-1: "white"} # device_num: strings of color names

func _ready():
	$HUD.visible = true
	$HUD/Tag.disabled = true
	$PlayerSettingsViewportContainer.visible = false
	$HUD/FreePlay.disabled = false

	set_physics_process(false)
	# set floor
	# var floor_rect = RectangleShape2D.new()
	# floor_rect.size = Vector2(2000, 50)
	# $Floor/CollisionShape2D.shape = floor_rect
	# $Floor.global_position = Vector2(1920/2., 1000)
	# $Floor.freeze = true



	# set player - TODO move to start_game()
	# player = load("res://player.tscn").instantiate()
	# player.global_position = Vector2(-200., -200.)
	# player.set_physics_process(false)
	# add_child(player)





func game_mode_chosen(gamemode_: String):
	gamemode = load("res://game_modes/" + gamemode_ + ".tscn").instantiate()
	gamemode.player_setup_information(devices, colors)
	add_child(gamemode)
	$HUD.visible = false


func settings():
	$HUD.visible = false
	$PlayerSettingsViewportContainer/SubViewport/PlayerSettings.open()
	$PlayerSettingsViewportContainer.visible = true
	
	


# called by PlayerSettings
func exit_settings(devices_: Array, colors_: Dictionary) -> void:
	$HUD.visible = true
	$PlayerSettingsViewportContainer.visible = false

	devices = devices_.duplicate()
	colors = colors_.duplicate()
	num_players = len(devices)


	$HUD/Dodge.disabled = false
	$HUD/Tutorial.disabled = false
	$HUD/Parkour.disabled = false
	$HUD/Tag.disabled = false
	if num_players > 1:
		# block single player games
		$HUD/Dodge.disabled = true
		$HUD/Tutorial.disabled = true
		$HUD/Parkour.disabled = true
	else:
		# block games that require >1 people
		$HUD/Tag.disabled = true
	


# back to main
func back():
	gamemode.queue_free()
	gamemode = null
	$HUD.visible = true
































































	# temp object
	# var temp_obj = load("res://object.tscn").instantiate()
	# var rect = RectangleShape2D.new()
	# rect.size = Vector2(150,150)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(700,300)
	# temp_obj.get_node("ColorRect").size = Vector2(150,150)
	# temp_obj.get_node("ColorRect").position = Vector2(-75,-75)
	# add_child(temp_obj)
	
	# temp_obj = load("res://object.tscn").instantiate()
	# rect = RectangleShape2D.new()
	# rect.size = Vector2(150,150)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(900,1000)
	# temp_obj.get_node("ColorRect").size = Vector2(150,150)
	# temp_obj.get_node("ColorRect").position = Vector2(-75,-75)
	# add_child(temp_obj)

	# temp_obj = load("res://object.tscn").instantiate()
	# rect = RectangleShape2D.new()
	# rect.size = Vector2(150,150)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(1400,700)
	# temp_obj.get_node("ColorRect").size = Vector2(150,150)
	# temp_obj.get_node("ColorRect").position = Vector2(-75,-75)
	# add_child(temp_obj)

	# temp_obj = load("res://object.tscn").instantiate()
	# rect = RectangleShape2D.new()
	# rect.size = Vector2(150,150)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(900,500)
	# temp_obj.get_node("ColorRect").size = Vector2(150,150)
	# temp_obj.get_node("ColorRect").position = Vector2(-75,-75)
	# add_child(temp_obj)

	# temp_obj = load("res://object.tscn").instantiate()
	# rect = RectangleShape2D.new()
	# rect.size = Vector2(150,150)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(1400,300)
	# temp_obj.get_node("ColorRect").size = Vector2(150,150)
	# temp_obj.get_node("ColorRect").position = Vector2(-75,-75)
	# add_child(temp_obj)

	# temp_obj = load("res://object.tscn").instantiate()
	# rect = RectangleShape2D.new()
	# rect.size = Vector2(50,1000)
	# temp_obj.get_node("CollisionShape2D").shape = rect
	# temp_obj.global_position = Vector2(1850,500)
	# temp_obj.get_node("ColorRect").size = Vector2(50,1000)
	# temp_obj.get_node("ColorRect").position = Vector2(-25,-500)
	# add_child(temp_obj)
































































# var five_seconds = 5.
# var total_time = 0.0
# func _physics_process(delta: float) -> void:
# 	total_time += delta

# 	five_seconds -= delta
# 	if five_seconds <= 0:
# 		$Floor/CollisionShape2D.disabled = true
# 		$Floor.visible = false

# 	timer -= delta
# 	if timer <= 0:
# 		timer = .5 + int(total_time/5.) * 0.1
# 	else:
# 		return
	
# 	var obj_inst = preload("res://object.tscn").instantiate()
				

# 	obj_inst.get_node("CollisionShape2D").shape = RectangleShape2D.new()
# 	obj_inst.get_node("CollisionShape2D").shape.size = Vector2(150, 150)
# 	obj_inst.get_node("ColorRect").size = Vector2(150, 150)
# 	obj_inst.get_node("ColorRect").position = Vector2(-75, -75)
# 	obj_inst.global_position = Vector2(randf() * 1920, -200)
# 	obj_inst.linear_velocity = Vector2(0, 300)
# 	obj_inst.setUp(player)

# 	objects.append(obj_inst)

# 	add_child(obj_inst)



# 	if player.global_position.y >= 1300:
# 		end_game()



# func end_game():
# 	$HUD/Start.visible = true
# 	$HUD/Label.visible = true
# 	set_physics_process(false)
# 	player.set_physics_process(false)
# 	$HUD/Label.text = "You died L"
# 	for i in range(len(objects)):
# 		if is_instance_valid(objects[i]):
# 			objects[i].queue_free()
# 	objects = []

# func start_game():
# 	$HUD/Start.visible = false
# 	$HUD/Label.visible = false
# 	score = 0
# 	$HUD/Label2.text = "0"
# 	$Floor/CollisionShape2D.disabled = false
# 	$Floor.visible = true
# 	player.global_position = Vector2(1920/2., 900)
# 	player.set_physics_process(true)
# 	five_seconds = 5.
# 	total_time = 0.0
# 	set_physics_process(true)

# func increment_score():
# 	score += 1
# 	$HUD/Label2.text = str(score)

# func remove_object(obj):
# 	objects.erase(obj)
# 	obj.queue_free()
