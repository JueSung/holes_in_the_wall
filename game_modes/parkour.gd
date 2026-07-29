extends Node2D
class_name Parkour

# parkour maps must have a node called StartPlatform, the Parkour_end_area node, and checkpoints named with scheme "Checkpoint#"


# handler of parkour maps
var map = null

const INPUT_COOLDOWN := .3
var input_cooldown := 0.0

var checkpoints := {} # key is node, value is number so ordering or whatever
var current_checkpoint = null # null means go back to start

var cameraPath = null

var timer := 0.0
var timer_lock := true

func player_setup_information(devices_, colors_):
	$Player.set_device_num(devices_[0]) # handles setting input set
	$Player.set_color(colors_[devices_[0]])

func _ready() -> void:
	$Player.visible = false
	$Player/Hurtbox.connect("body_entered", body_entered)

	$HUD.visible = true
	$GameHUD.visible = false

func level_selected(name_: String) -> void:
	$HUD.visible = false
	$GameHUD.visible = true
	
	checkpoints = {}
	current_checkpoint = null
	cameraPath = null
	$Player.call_deferred("disable_hitboxes") # so don't insta end; doesn't even last cuz next frame _physics_process will just set it back
	
	
	if map && is_instance_valid(map):
		map.queue_free()

	map = load("res://game_modes/parkour_maps/" + name_ + ".tscn").instantiate()
	add_child(map)
	

	# player setup
	place_player()
	$Player.visible = true
	$Player.set_physics_process(true)
	$Player.set_process(true)


	# collect area things
	map.get_node("Parkour_end_area").connect("body_entered", end_entered)
	
	for child in map.get_children():
		if "Checkpoint" in child.name:
			child.get_node("ColorRect").color = Color8(100, 100, 100, 180)
			checkpoints[child] = int(str(child.name)[10]) # should be number
			child.body_entered.connect(checkpoint_entered.bind(child))
		if child.name == "CameraPath":
			cameraPath = map.get_node("CameraPath") # may be null
	
	
	timer = 0.0
	timer_lock = false
	$GameHUD/Timer.text = "%.3f" % timer

# places player at starting position, for getting reset/starting
func place_player():
	if map: # failsafe
		$Player.reset()
		if current_checkpoint == null:
			$Player.global_position = map.get_node("StartPlatform").global_position - Vector2(0, 120)
		else:
			$Player.global_position = current_checkpoint.global_position - Vector2(0, 110)

# for dying and resetting to last checkpoint or whatever
# signal by Player
func body_entered(body):
	if body is CustomObject && body.dangerous:
		$Player.set_process(false)
		input_cooldown = INPUT_COOLDOWN
		$Player.reset()
		place_player()

# called by checkpoint area
func checkpoint_entered(body, checkpoint):
	if body is Player:
		if !current_checkpoint || checkpoints[checkpoint] > checkpoints[current_checkpoint]:
			current_checkpoint = checkpoint
			checkpoint.get_node("ColorRect").color = Color8(66, 230, 252, 180)

func end_entered(body):
	if body is Player:
		# end game
		timer_lock = true
		$Player.set_process(false)
		$Player.reset()
		$HUD.visible = true
		$HUD/Title.text = "Hooray you did it! Time was:\n%.3f" % timer + " seconds!"
		$GameHUD.visible = false


func _process(delta: float) -> void:
	if !timer_lock:
		timer += delta
		$GameHUD/Timer.text = "%.3f" % timer


func _physics_process(delta):
	if input_cooldown > 0:
		input_cooldown -= delta
		if input_cooldown <= 0:
			$Player.set_process(true)
	
	if cameraPath:
		cameraPath.get_node("PathFollow2D").progress = cameraPath.curve.get_closest_offset(cameraPath.to_local($Player.global_position)) #(roundi(cameraPath.curve.get_closest_offset(cameraPath.to_local($Player.global_position))/800)) * 800
		cameraPath.get_node("PathFollow2D/Camera2D").position = 100 * $Player.velocity.normalized()
		cameraPath.get_node("PathFollow2D/Camera2D").rotation = cameraPath.get_node("PathFollow2D").progress / 3780. * 4 * PI



func back_to_main():
	get_parent().back()


func exit_level() -> void:
	$GameHUD.hide()
	$HUD.show()
	$HUD/Title.text = "Parkour"
	$Player.set_physics_process(false)
	$Player.set_process(false)
