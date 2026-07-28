@tool
extends RigidBody2D
class_name CustomObject
var player: Player = null



@export var platform_shape: Vector2 = Vector2(150, 150):
    set(shape_):
        platform_shape = shape_
        $CollisionShape2D.shape = RectangleShape2D.new()
        $CollisionShape2D.shape.size = shape_
        $ColorRect.size = shape_
        $ColorRect.position = shape_ / -2.

@export var dangerous: bool = false:
    set(dangerous_):
        dangerous = dangerous_
        if !dangerous:
            $ColorRect.color = Color8(72, 72, 72, 255 * 255)
            z_index = 0
        else:
            $ColorRect.color = Color(1, .2, .2, 1)
            z_index = 1

@export var preset: String = "":
    set(preset_):
        preset = preset_
        match preset:
            "floor":
                platform_shape = Vector2(1920, 40)
                global_position = Vector2(960., 1080)
            "ceiling":
                platform_shape = Vector2(1920, 40)
                global_position = Vector2(960., 0)
            "left_wall":
                platform_shape = Vector2(40, 1080)
                global_position = Vector2(0, 540)
            "right_wall":
                platform_shape = Vector2(40, 1080)
                global_position = Vector2(1920, 540)

# var has_scored = false

# func setUp(player_):
#     player = player_



# func _physics_process(_delta: float) -> void:
#     if global_position.y > 1300:
#         get_parent().remove_object(self)
#     if player && global_position.y >= player.global_position.y && !has_scored:
#         get_parent().increment_score()
#         has_scored = true