extends Node2D
class_name Tag

var map = null

var paused := false

var who_it := 0 # 1 or 2 - set by start_game

var timer := 3. # 1 minute game
const GAME_LENGTH := 3.
var tag_cooldown := .1
const TAG_COOLDOWN := .1


func _ready() -> void:
	$HUD/Start_Game.visible = false
	$HUD/MapSelection.visible = false
	
	$GameHUD.visible = false
	set_physics_process(false)
	$Player1/Hurtbox.connect("area_entered", area_entered)
	$Player2/Hurtbox.connect("area_entered", area_entered)



func two_players():
	$HUD/MapSelection.visible = true
	$HUD/Start_Game.visible = true




func start_game():
	var chosen_map = $HUD/MapSelection.get_chosen_map()
	if chosen_map == "":
		$HUD/Label.text = "Choose a Map bruh"
		return
	# reset HUD
	$HUD.visible = false
	$HUD/MapSelection.visible = false
	$HUD/TwoPlayers.button_pressed = false
	$HUD/MapSelection/Map1_button.button_pressed = false
	$HUD/MapSelection/Map2_button.button_pressed = false
	$HUD/Start_Game.visible = false
	$GameHUD.visible = true
	map = load(chosen_map).instantiate()
	add_child(map)

	
	$Player1.global_position = Vector2(1920 * .25, 800)
	$Player2.global_position = Vector2(1920 * .75, 800)
	$Player1.set_physics_process(true)
	$Player1.set_process(true)
	$Player2.set_physics_process(true)
	$Player2.set_process(true)

	who_it = int(randf() * 2) + 1
	if who_it == 1:
		$Player1.modulate = Color(1, .4, .4, 1)
		$Player2.modulate = Color(1, 1, 1, 1)
	else:
		$Player1.modulate = Color(1, 1, 1, 1)
		$Player2.modulate = Color(1, .4, .4, 1)
   
	timer = GAME_LENGTH
	set_physics_process(true)

func end_game():
	set_physics_process(false)
	$Player1.set_physics_process(false)
	$Player2.set_physics_process(false)
	$Player1.set_process(false)
	$Player2.set_process(false)
	map.queue_free()
	map = null
	$GameHUD.visible = false
	$HUD.visible = true
	$HUD/MapSelection.visible = false
	$HUD/Label.text = "Player 1 Won!" if who_it == 2 else "Player 2 Won!"

func _physics_process(delta: float) -> void:
	if tag_cooldown > 0:
		tag_cooldown -= delta
	timer -= delta
	$GameHUD/Timer.text = str(int(timer))
	if timer <= 0:
		end_game()


func area_entered(area):
	if tag_cooldown > 0:
		return
	if area.get_parent() is Player:
		# swap whos it
		if who_it == 1:
			who_it = 2
			$Player1.modulate = Color(1, 1, 1, 1)
			$Player2.modulate = Color(1, .4, .4, 1)
		else:
			who_it = 1
			$Player1.modulate = Color(1, .4, .4, 1)
			$Player2.modulate = Color(1, 1, 1, 1)
		tag_cooldown = TAG_COOLDOWN





func pause() -> void:
	if !paused:
		paused = true
		set_physics_process(false)
		$Player1.set_physics_process(false)
		$Player2.set_physics_process(false)
		$Player1.set_process(false)
		$Player2.set_process(false)
		$GameHUD/Pause.text = "Unpause"
	else:
		paused = false
		set_physics_process(true)
		$Player1.set_physics_process(true)
		$Player2.set_physics_process(true)
		$Player1.set_process(true)
		$Player2.set_process(true)
		$GameHUD/Pause.text = "Pause"
