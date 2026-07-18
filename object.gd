extends RigidBody2D



func _physics_process(_delta: float) -> void:
    if global_position.y > 1300:
        get_parent().remove_object(self)