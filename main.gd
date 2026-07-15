extends Node
class_name Main

var player : Player = null # set by ready

var timer : float = 0.0
var objects : Array = []

func _ready():
	# set floor
	var floor_rect = RectangleShape2D.new()
	floor_rect.size = Vector2(2000, 50)
	$Floor/CollisionShape2D.shape = floor_rect
	$Floor.global_position = Vector2(1920/2., 1000)
	$Floor.freeze = true

	$Floor/TextureRect.size = Vector2(2000,50)
	$Floor/TextureRect.position = Vector2(-1000,-25)

	# set player - TODO move to start_game()
	player = load("res://player.tscn").instantiate()
	player.global_position = Vector2(1920/2., 900)
	add_child(player)



	# temp object
	var temp_obj = load("res://object.tscn").instantiate()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(150,150)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(500,900)
	temp_obj.get_node("TextureRect").size = Vector2(150,150)
	temp_obj.get_node("TextureRect").position = Vector2(-75,-75)
	add_child(temp_obj)
	
	temp_obj = load("res://object.tscn").instantiate()
	rect = RectangleShape2D.new()
	rect.size = Vector2(150,150)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(800,700)
	temp_obj.get_node("TextureRect").size = Vector2(150,150)
	temp_obj.get_node("TextureRect").position = Vector2(-75,-75)
	add_child(temp_obj)

	temp_obj = load("res://object.tscn").instantiate()
	rect = RectangleShape2D.new()
	rect.size = Vector2(150,150)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(500,500)
	temp_obj.get_node("TextureRect").size = Vector2(150,150)
	temp_obj.get_node("TextureRect").position = Vector2(-75,-75)
	add_child(temp_obj)

	temp_obj = load("res://object.tscn").instantiate()
	rect = RectangleShape2D.new()
	rect.size = Vector2(150,150)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(800,300)
	temp_obj.get_node("TextureRect").size = Vector2(150,150)
	temp_obj.get_node("TextureRect").position = Vector2(-75,-75)
	add_child(temp_obj)

	temp_obj = load("res://object.tscn").instantiate()
	rect = RectangleShape2D.new()
	rect.size = Vector2(150,150)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(1400,300)
	temp_obj.get_node("TextureRect").size = Vector2(150,150)
	temp_obj.get_node("TextureRect").position = Vector2(-75,-75)
	add_child(temp_obj)

	temp_obj = load("res://object.tscn").instantiate()
	rect = RectangleShape2D.new()
	rect.size = Vector2(50,1000)
	temp_obj.get_node("CollisionShape2D").shape = rect
	temp_obj.global_position = Vector2(1850,500)
	temp_obj.get_node("TextureRect").size = Vector2(50,1000)
	temp_obj.get_node("TextureRect").position = Vector2(-25,-500)
	add_child(temp_obj)



# func _physics_process(delta: float) -> void:
# 	timer -= delta
# 	if timer <= 0:
# 		timer = .025
# 	else:
# 		return
	
# 	var num_times = 1
# 	for i in range(num_times):
# 			# spawn object along top
# 			var obj_inst = preload("res://object.tscn").instantiate()
# 			var dim = Vector2(int(randf() * 150 + 10), int(randf() * 150 + 10))
			
# 			obj_inst.get_node("CollisionShape2D").shape = RectangleShape2D.new()
# 			obj_inst.get_node("CollisionShape2D").shape.size.x = dim.x
# 			obj_inst.get_node("CollisionShape2D").shape.size.y = dim.y
# 			obj_inst.get_node("TextureRect").size = dim
# 			obj_inst.get_node("TextureRect").position = dim / -2.
# 			var side = int(randf() * 2)
# 			var speed = randf() * 1000 + 300
# 			#obj_inst.setUp(side)
# 			match side:
# 				0: # bottom
# 					obj_inst.linear_velocity = speed * Vector2(0, -1)
# 					obj_inst.global_position = Vector2(randf() * 1920 * 2, 1200)
# 				1: # left
# 					obj_inst.linear_velocity = speed * Vector2(1, 0)
# 					obj_inst.global_position = Vector2(-200, randf() * 1920 * 2)
# 				2: # right
# 					obj_inst.linear_velocity = speed * Vector2(-1, 0)
# 					obj_inst.global_position = Vector2(1920 * 2 + 200, randf() * 1920 * 2)
# 			objects.append(obj_inst)
			
# 			add_child(obj_inst)
