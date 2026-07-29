extends Node2D


func _ready() -> void:
    $Player.set_animation("wall_clutch", Vector2i(1, 0))
    $Player.freeze()
    $Player2.set_animation("dash", Vector2i(1, 0))
    $Player2.freeze()
    $Player3.set_animation("jump", Vector2i(-1, 1))
    $Player3.freeze()
