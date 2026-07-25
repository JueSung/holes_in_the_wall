extends Node2D
class_name Tag

var map = null

var paused := false

# player information devices/customization for instantiation of players stuff
var devices := []
var colors := {}

var players = []
var num_players = 2 # default is 2
var who_it := 0 # 1 or 2 or whatever number- set by start_game - index of player in players is who_it-1

var timer := 60. # 1 minute game
const GAME_LENGTH := 60.
var tag_cooldown := .5
const TAG_COOLDOWN := .5


var num_controllers: int = 0

@onready var it_pointer = $it_pointer

func player_setup_information(devices_, colors_):
	devices = devices_.duplicate()
	colors = colors_.duplicate()
	num_players = len(devices)

func _ready() -> void:
	$HUD/MapSelection.visible = true
	$HUD/Start_Game.visible = true
	
	$GameHUD.visible = false
	set_physics_process(false)

	$it_pointer.visible = false




func start_game():
	var chosen_map = $HUD/MapSelection.get_chosen_map()
	if chosen_map == "":
		$HUD/Label.text = "Choose a Map bruh"
		return
	# reset HUD
	$HUD.visible = false
	$HUD/MapSelection.visible = false
	$HUD/MapSelection/Map1_button.button_pressed = false
	$HUD/MapSelection/Map2_button.button_pressed = false
	$GameHUD.visible = true


	for i in range(len(players)):
		if is_instance_valid(players[i]):
			players[i].queue_free()
	players = []

	for i in range(num_players):
		var player = preload("res://player.tscn").instantiate()
		player.get_node("Hurtbox").area_entered.connect(area_entered.bind(player.get_node("Hurtbox")))
		player.global_position = Vector2(1920 * (i+1.)/(num_players+1), 800)
		players.append(player)
		
		add_child(player)
		player.set_color(colors[devices[i]])
		player.set_physics_process(true)
		player.set_process(true)

		player.set_player_num(i + 1)

		player.set_device_num(devices[i])
	
	# set up map after players so if map needs players, can grab using get_players() and to set player positions if needed
	map = load(chosen_map).instantiate()
	add_child(map)


	
	it_pointer.visible = true

	who_it = int(randf() * num_players) + 1
	it_pointer.reparent(players[who_it-1])
	it_pointer.position = Vector2(-7.5, -70)
   
	timer = GAME_LENGTH
	set_physics_process(true)

func end_game():
	set_physics_process(false)
	for i in range(len(players)):
		players[i].set_physics_process(false)
		players[i].set_process(false)
	map.queue_free()
	map = null
	$GameHUD.visible = false
	$HUD.visible = true
	$HUD/MapSelection.visible = true
	$HUD/Label.text = "Player " + str(who_it) + " died! L"

func _physics_process(delta: float) -> void:
	if tag_cooldown > 0:
		tag_cooldown -= delta
		if tag_cooldown <= 0:
			players[who_it-1].set_physics_process(true)
			players[who_it-1].set_process(true)
	timer -= delta
	$GameHUD/Timer.text = str(int(timer))
	if timer <= 0:
		end_game()


func area_entered(tagged_area, sender_area):
	if tag_cooldown > 0:
		return
	var sender = sender_area.get_parent()
	if !(sender is Player && sender.player_num == who_it):
		return
	var tagged = tagged_area.get_parent()
	if tagged is Player:
		who_it = tagged.player_num
		it_pointer.reparent(players[who_it-1])
		it_pointer.position = Vector2(-7.5, -70)
		tag_cooldown = TAG_COOLDOWN
		tagged.set_physics_process(false)
		tagged.set_process(false)




func pause() -> void:
	if !paused:
		paused = true
		set_physics_process(false)
		for i in range(len(players)):
			players[i].set_physics_process(false)
			players[i].set_process(false)
		$GameHUD/Pause.text = "Unpause"
	else:
		paused = false
		set_physics_process(true)
		for i in range(len(players)):
			players[i].set_physics_process(true)
			players[i].set_process(true)
		$GameHUD/Pause.text = "Pause"


func back_to_main() -> void:
	get_parent().back()

# for maps and stuff if they want to do weird things *ahem map 4
func get_players():
	return players