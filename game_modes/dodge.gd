extends Node2D
class_name Dodge

var timer := 0.


var devices := []
var colors := {}

var players = []
# for multiplayer:
var alive_players = []
var winner = null
#----------------------
var num_players = 0

var objects = []


var spawn_timer := 0.

func player_setup_information(devices_, colors_):
	# do we need this?
	devices = devices_
	colors = colors_

	num_players = len(devices_)


	# $Player.set_device_num(devices[0]) # handles setting input set
	# $Player.set_color(colors[devices[0]])

func _ready() -> void:
	$HUD.visible = true
	$GameHUD.visible = false
	set_physics_process(false)

	if num_players * 50 > 150:
		$Map/Platform.platform_shape = Vector2(num_players * 50, 150)

	for i in range(num_players):
		var player = load("res://player.tscn").instantiate()
		player.get_node("Hurtbox").body_entered.connect(player_body_entered.bind(player))
		players.append(player)
		alive_players.append(player)
		add_child(player)

		player.set_color(colors[devices[i]])
		player.set_physics_process(true)
		player.set_process(true)

		player.set_device_num(devices[i])
	
		set_player_position(i)
		

	# $Player/Hurtbox.connect("body_entered", player_body_entered)
	
	# $Player.set_physics_process(true)
	# $Player.set_process(true)
	


func start():
	$HUD.visible = false
	$GameHUD.visible = true
	timer = 0.
	set_physics_process(true)
	alive_players = players.duplicate()
	winner = null

	for i in range(len(players)):
		set_player_position(i)
		players[i].modulate = Color(1,1,1,1)
		players[i].reset()
		players[i].set_physics_process(true)
		players[i].set_process(true)
	# $Player.global_position = Vector2(960, 650)
	# $Player.reset()
	# $Player.set_physics_process(true)
	for i in range(len(objects)):
		if is_instance_valid(objects[i]):
			objects[i].queue_free()
	objects = []

func _physics_process(delta: float) -> void:
	timer += delta
	$GameHUD/Timer.text = str(int(timer))

	spawn_timer -= delta
	if spawn_timer > 0:
		return
	spawn_timer = max(4.-timer * .025, .1)

	# generate thingies
	for i in range(2): # one good one bad
		var coll_inst = preload("res://object.tscn").instantiate()
		# random shape
		if i == 0:
			coll_inst.platform_shape = Vector2(randf() * 590 + 10, randf() * 590 + 10)
		else: # danger one
			coll_inst.platform_shape = Vector2(randf() * 290 + 10, randf() * 290 + 10)
			coll_inst.dangerous = true
		
		# figure out spot along border to spawn (will be about 300 block border outside tho), only ceiling, left, right
		var num = randf() * ((3120) + (2280) * 2)
		if num < 3120: # ceiling
			coll_inst.global_position = Vector2(num-600, -600)
		elif num < 3120+2280: # left
			coll_inst.global_position = Vector2(-600, num-3120-600)
		else: # right
			coll_inst.global_position = Vector2(1920 + 600, num-3120-2280-600)
		
		var avg_pos = Vector2.ZERO #average position of all players
		for j in range(len(alive_players)):
			avg_pos += players[j].global_position
		if len(alive_players) > 0:
			avg_pos /= len(alive_players)
		# velocity # target at player current position
		
		coll_inst.linear_velocity = (randf() * 300 + 150) * (avg_pos - coll_inst.global_position + Vector2(randf() * 20-10, randf() * 20-10)).normalized()
		# coll_inst.linear_velocity = (randf() * 300 + 150) * ($Player.global_position - coll_inst.global_position + Vector2(randf() * 20-10, randf() * 20-10)).normalized()
		coll_inst.angular_velocity = randf() * PI/2. - PI/4.
		
		objects.append(coll_inst)
		add_child(coll_inst)
	

	# just check once in a while basically since will often return early
	for i in range(len(objects)):
		var j = len(objects)-1-i
		if !is_instance_valid(objects[j]):
			objects.remove_at(j)
			continue
		var x = objects[j].global_position.x
		var y = objects[j].global_position.y
		if x < -600 || x > 1920 + 600 || y < -600 || y > 1620:
			objects[j].queue_free()
			objects.remove_at(j)





func end_game():
	if num_players == 1:
		$HUD/Label.text = "You Died!\nTime: %.3f" % timer + " seconds"
	else:
		$HUD/Label.text = "Player " + winner.get_color() + " won!\nTime: %.3f" % timer + " seconds"
	$HUD.visible = true
	set_physics_process(false)
	for i in range(len(players)):
		players[i].set_physics_process(false)
	# $Player.set_physics_process(false)
	for i in range(len(objects)):
		if is_instance_valid(objects[i]):
			objects[i].linear_velocity = Vector2.ZERO
			objects[i].angular_velocity = 0



func set_player_position(ind):
	if ind == -1:
		return
	players[ind].global_position = Vector2(960 + 50 * (ind - int(num_players/2.)) + 20 * ((num_players % 2) * -1 + 1), 650)
	# if num_players * 40 <= 150:
	# 	for i in range(num_players):
	# 		players[i].global_position = Vector2()
	# else: # expanded platform
	# 	for i in range(num_players):
	# 		players[i].global_position = Vector2(1920/2., 650 + randf() * 10 - 5) # TODO change




func back_to_main():
	get_parent().back()

func player_body_entered(body: Node, player) -> void:
	if body is CustomObject && body.dangerous:
		if timer == 0.:
			# just put player back
			set_player_position(players.find(player))
			# $Player.position = Vector2(960, 650)
		else:
			if num_players == 1:
				end_game()
			else:
				player.modulate = Color(1, 1, 1, .5)
				player.set_physics_process(false)
				player.set_process(false)
				alive_players.erase(player)
				if len(alive_players) == 1:
					winner = alive_players[0]
				elif len(alive_players) == 0:
					end_game()
