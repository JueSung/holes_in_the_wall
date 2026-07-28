@tool
extends Area2D
class_name ParkourEndArea

@export var collision_dimensions: Vector2 = Vector2(150, 150):
    set(shape_):
        collision_dimensions = shape_
        $CollisionShape2D.shape = RectangleShape2D.new()
        $CollisionShape2D.shape.size = shape_
        $ColorRect.size = shape_
        $ColorRect.position = shape_ / -2.