extends CanvasLayer
class_name PlayerSettings

var main: Main = null

# 0 will be controller, 1, 2, 3 are also controllers
# -1, -2, ... will be keyboard sites
var devices := []
var players := {} # device : player object
var colors := {} # device : color
# num_players is just len of devices
var num_keyboarders := 0

func _ready() -> void:
	main = get_tree().root.get_node("Main")
	$NumKeyboarders.value = 1
	set_process_unhandled_input(false)



func _unhandled_input(event: InputEvent) -> void:
	if event.device not in devices:
		if !event is InputEventJoypadButton:
			return # either keyboard, or could be joystick drift, force join to be button
		devices.append(event.device)
		
		var inst = load("res://player.tscn").instantiate()
		inst.set_device_num(event.device) # handles input_set
		inst.global_position = Vector2(1920/2., 300)
		players[event.device] = inst
		colors[event.device] = "white"

		inst.get_node("Hurtbox").body_entered.connect(body_entered.bind(inst))
		add_child(inst)
		inst.set_physics_process(true)
		inst.set_process(true)



func num_keyboard_players_changed(value: float) -> void:
	if num_keyboarders == int(value):
		return
	$NumKeyboardersNum.text = str(int(value))
	if num_keyboarders < int(value):
		for i in range(int(value)-num_keyboarders):
			var inst = load("res://player.tscn").instantiate()
			inst.set_device_num(-1 * (num_keyboarders + 1 + i))
			inst.global_position = Vector2(1920/2. + (randf() * 200 - 100), 300)
			devices.append(inst.get_device_num())
			players[inst.get_device_num()] = inst
			colors[inst.get_device_num()] = "white"

			inst.get_node("Hurtbox").body_entered.connect(body_entered.bind(inst))
			add_child(inst)
			inst.set_physics_process(true)
			inst.set_process(true)
	else: # num_keyboarders > int(value)
		for i in range(num_keyboarders - int(value)):
			var device_num = -1 * (num_keyboarders - i)
			if is_instance_valid(players[device_num]):
				players[device_num].queue_free()
				devices.erase(device_num)
				players.erase(device_num)
				colors.erase(device_num)
	num_keyboarders = int(value)



func color_change(player, color: String):
	if !(player is Player):
		return
	player.set_color(color)
	colors[player.get_device_num()] = color



func body_entered(body, player):
	if body is CustomObject && body.dangerous:
		if player.get_device_num() >= 0:
			# basically just remove player
			var device_num = player.get_device_num()
			if is_instance_valid(players[device_num]):
				players[device_num].queue_free()
			players.erase(device_num)
			colors.erase(device_num)
			devices.erase(device_num)
		else: # keyboardist
			player.global_position = Vector2(1920/2., 400)



func remove_all_players() -> void:
	$NumKeyboarders.value = 0
	for key in players:
		if is_instance_valid(players[key]):
			players[key].queue_free()
	devices = []
	players = {}
	colors = {}


func open():
	set_process_unhandled_input(true)
	for key in devices:
		players[key].set_physics_process(true)
		players[key].set_process(true)
		players[key].global_position = Vector2(1920/2. + (randf() * 200 - 100), 300)
		players[key].velocity = Vector2(0,0)

func back_to_main() -> void:
	if len(devices) == 0:
		return # need more than 0 players to play bruh
	set_process_unhandled_input(false)
	for key in players:
		players[key].set_physics_process(false)
		players[key].set_process(false)

	main.exit_settings(devices, colors)
