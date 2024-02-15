class_name Pipe
extends StaticBody2D


@export var speed := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= delta * speed
	if global_position.x < -300:
		queue_free()
