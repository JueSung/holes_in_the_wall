@tool
extends RigidBody2D
var player: Player = null



@export var platform_shape: Vector2 = Vector2(150, 150):
    set(shape_):
        platform_shape = shape_
        $CollisionShape2D.shape = RectangleShape2D.new()
        $CollisionShape2D.shape.size = shape_
        $TextureRect.size = shape_
        $TextureRect.position = shape_ / -2.


# var has_scored = false

# func setUp(player_):
#     player = player_



# func _physics_process(_delta: float) -> void:
#     if global_position.y > 1300:
#         get_parent().remove_object(self)
#     if player && global_position.y >= player.global_position.y && !has_scored:
#         get_parent().increment_score()
#         has_scored = true