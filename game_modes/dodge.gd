extends Node2D
class_name Dodge

var timer := 0.

var objects = []


var spawn_timer := 0.


func _ready() -> void:
	$HUD.visible = true
	$GameHUD.visible = false
	set_physics_process(false)

	$Player/Hurtbox.connect("body_entered", player_body_entered)
	
	$Player.set_physics_process(true)
	$Player.set_process(true)
	


func start():
	$HUD.visible = false
	$GameHUD.visible = true
	timer = 0.
	set_physics_process(true)
	$Player.position = Vector2(960, 650)
	$Player.set_physics_process(true)
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
	spawn_timer = 4.

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
		
		
		# velocity # target at player current position
		coll_inst.linear_velocity = (randf() * 300 + 150) * ($Player.global_position - coll_inst.global_position).normalized()
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
	$HUD/Label.text = "You Died!\nScore: " + str(int(timer)) + " seconds"
	$HUD.visible = true
	set_physics_process(false)
	$Player.set_physics_process(false)
	for i in range(len(objects)):
		if is_instance_valid(objects[i]):
			objects[i].linear_velocity = Vector2.ZERO
			objects[i].angular_velocity = 0








func back_to_main():
	get_parent().back()

func player_body_entered(body: Node) -> void:
	if body is CustomObject && body.dangerous:
		if timer == 0.:
			# just put player back
			$Player.position = Vector2(960, 650)
		else:
			end_game()
