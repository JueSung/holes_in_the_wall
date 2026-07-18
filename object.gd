extends RigidBody2D
var player: Player = null

var has_scored = false

func setUp(player_):
    player = player_



func _physics_process(_delta: float) -> void:
    if global_position.y > 1300:
        get_parent().remove_object(self)
    if player && global_position.y >= player.global_position.y && !has_scored:
        get_parent().increment_score()
        has_scored = true