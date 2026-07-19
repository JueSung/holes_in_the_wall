extends Node2D
class_name FreePlay

var map = null

func _ready() -> void:
    $Player.set_physics_process(false)
    $Player.set_process(false)

func start() -> void:
    var chosen_map = $HUD/MapSelection.get_chosen_map()
    if chosen_map == "":
        $HUD/Label.text = "Choose Map"
        return
    
    map = load(chosen_map).instantiate()
    add_child(map)
    $HUD.visible = false
    $Player.global_position = Vector2(1920/2., 800)
    $Player.set_physics_process(true)
    $Player.set_process(true)



