extends Node2D
class_name Tutorial


var camera_location_on_deck = Vector2(1920/2., 1080/2.)

# gets called by main for player set up stuff prior to add_child
func player_setup_information(devices, colors):
	$Player.set_device_num(devices[0]) # handles setting input set
	$Player.set_color(colors[devices[0]])

	$keyboard1.visible = false
	$keyboard2.visible = false
	$keyboard3.visible = false
	$controller.visible = false

	if devices[0] < 0:
		# keyboard
		get_node("keyboard" + str(-1 * devices[0])).visible = true
	else:
		# controller
		$controller.visible = true
		


func _ready() -> void:
	$Player.set_player_num(1)
	$Player.set_physics_process(true)
	$Player.set_process(true)

	$Player.global_position = Vector2(300, 900)

	$Player/Hurtbox.connect("body_entered", player_body_entered)

	
	$Map/Area2/Player.set_animation("crouch", Vector2i(0, 1))
	$Map/Area2/Player.freeze()

	$Map/Area3/Player.set_animation("wall_clutch", Vector2i(1, 0))
	$Map/Area3/Player.freeze()
	$Map/Area3/Player2.set_animation("jump", Vector2i(-1, 0))
	$Map/Area3/Player2.freeze()
	$Map/Area3/Player3.set_animation("wall_clutch", Vector2i(-1, 0))
	$Map/Area3/Player3.freeze()

	$Map/Area4/Player.set_animation("run", Vector2i(1, 0))
	$Map/Area4/Player.freeze()
	$Map/Area4/Player2.set_animation("jump", Vector2i(1, 0))
	$Map/Area4/Player2.freeze()
	$Map/Area4/Player3.set_animation("dash", Vector2i(1, 0))
	$Map/Area4/Player3.freeze()

	$Map/Area5/Player.set_animation("wall_clutch", Vector2i(1, 0))
	$Map/Area5/Player.freeze()
	$Map/Area5/Player2.set_animation("jump", Vector2i(-1, 0))
	$Map/Area5/Player2.freeze()
	$Map/Area5/Player3.set_animation("dash", Vector2i(-1, -1))
	$Map/Area5/Player3.freeze()
	$Map/Area5/Player4.set_animation("wall_clutch", Vector2i(-1, 0))
	$Map/Area5/Player4.freeze()
	




func _physics_process(_delta: float) -> void:
	# crouch
	if $Map/Area2/Object.global_position.x < 1300:
		$Map/Area2/Object.global_position.x = 1740




func player_body_entered(body):
	if body is CustomObject && body.dangerous:
		$Player.global_position = Vector2(2300, 600)


func area1_entered(body):
	if body is Player:
		camera_location_on_deck = $Map/Area1.global_position
		
func area2_entered(body):
	if body is Player:
		camera_location_on_deck = $Map/Area2.global_position

func area3_entered(body):
	if body is Player:
		camera_location_on_deck = $Map/Area3.global_position

func area4_entered(body):
	if body is Player:
		camera_location_on_deck = $Map/Area4.global_position

func area5_entered(body):
	if body is Player:
		camera_location_on_deck = $Map/Area5.global_position

func area1_exited(body):
	if body is Player && camera_location_on_deck != $Map/Area1.global_position:
		$Camera2D.position = camera_location_on_deck

func area2_exited(body):
	if body is Player && camera_location_on_deck != $Map/Area2.global_position:
		$Camera2D.position = camera_location_on_deck

func area3_exited(body):
	if body is Player && camera_location_on_deck != $Map/Area3.global_position:
		$Camera2D.position = camera_location_on_deck

func area4_exited(body):
	if body is Player && camera_location_on_deck != $Map/Area4.global_position:
		$Camera2D.position = camera_location_on_deck

func area5_exited(body):
	if body is Player && camera_location_on_deck != $Map/Area5.global_position:
		$Camera2D.position = camera_location_on_deck


func back_to_main() -> void:
	get_parent().back()
