extends Node2D
class_name Map4


var players = []
var player_tp_cooldowns = [] # so players can actualy leave hole when tp-ing
var player_input_cooldowns = [] # so players can't get stuck in hole or whatever by dashing
var player_inside_area = [] # in case of body blocking gets teleported out if stuck in area
const TP_COOLDOWN := .1
const INPUT_COOLDOWN := .2 # probably perfect amount of time

@onready var areas = [$HoleBottomLeft, $HoleBottomRight, $HoleMidLeft, $HoleMidRight, $HoleTopLeft, $HoleTopRight]

var map_has_set_positions := false

const EXIT_SPEED = 1000.

func _ready() -> void:
	players = get_parent().get_players() # should work
	for i in range(len(players)):
		players[i].global_position = Vector2(960 * (i+1.)/(len(players)+1), 440)
		players[i].get_node("Hurtbox").area_entered.connect(area_entered.bind(players[i]))
		players[i].get_node("Hurtbox").area_exited.connect(area_exited.bind(players[i]))

		player_tp_cooldowns.append(0.0)
		player_input_cooldowns.append(0.0)
		player_inside_area.append(null)



func _physics_process(delta: float) -> void:
	for i in range(len(player_tp_cooldowns)):
		if player_tp_cooldowns[i] > 0:
			player_tp_cooldowns[i] -= delta
			if player_tp_cooldowns[i] <= 0 && player_inside_area[i] != null:
				area_entered(player_inside_area[i], players[i])
		if player_input_cooldowns[i] > 0:
			player_input_cooldowns[i] -= delta
			if player_input_cooldowns[i] <= 0:
				players[i].set_process(true)


func area_exited(area, player):
	var ind = players.find(player)
	if ind == -1:
		return
	if area == player_inside_area[ind]:
		player_inside_area[ind] = null


func area_entered(area, player):
	var ind = players.find(player)
	if ind == -1 || player_tp_cooldowns[ind] > 0:
		return
	player_tp_cooldowns[ind] = TP_COOLDOWN
	player_input_cooldowns[ind] = INPUT_COOLDOWN
	player.set_process(false)
	# guess is area can only be one made on the map cuz no other areas exist?
	var rand_ind := int(randf() * (len(areas)-1))
	var exit_ind := -1 # will get overwritten
	var area_found := false
	for i in range(len(areas)):
		if area == areas[i]:
			exit_ind = rand_ind + 1 if rand_ind > i-1 else rand_ind
			area_found = true
			break
	if !area_found:
		return # this area not a hole
	
	player.reset()
	player.global_position = areas[exit_ind].global_position

	player_inside_area[ind] = areas[exit_ind]

	match exit_ind:
		0:
			player.velocity = EXIT_SPEED * Vector2(0, -1)
		1:
			player.velocity = EXIT_SPEED * Vector2(0, -1)
		2:
			player.velocity = 1.5 * EXIT_SPEED * Vector2(1, 0)
		3:
			player.velocity = 1.5 * EXIT_SPEED * Vector2(-1, 0)
		4:
			player.velocity = EXIT_SPEED * Vector2(0, 1)
		5:
			player.velocity = EXIT_SPEED * Vector2(0, 1)
