extends Node
class_name Main

var player: Player = null # set by ready

func _ready():
    # set floor
    var floor_rect = RectangleShape2D.new()
    floor_rect.size = Vector2(2000, 50)
    $Floor/CollisionShape2D.shape = floor_rect
    $Floor.global_position = Vector2(1920/2., 1000)
    $Floor.freeze = true

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
    add_child(temp_obj)
    
    temp_obj = load("res://object.tscn").instantiate()
    rect = RectangleShape2D.new()
    rect.size = Vector2(150,150)
    temp_obj.get_node("CollisionShape2D").shape = rect
    temp_obj.global_position = Vector2(800,700)
    add_child(temp_obj)

    temp_obj = load("res://object.tscn").instantiate()
    rect = RectangleShape2D.new()
    rect.size = Vector2(50,1000)
    temp_obj.get_node("CollisionShape2D").shape = rect
    temp_obj.global_position = Vector2(1850,500)
    add_child(temp_obj)