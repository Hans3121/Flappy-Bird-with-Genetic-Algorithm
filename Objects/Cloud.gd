extends Sprite2D

var speed : int = 100

func _process(delta: float) -> void:
	position.x -= speed*delta
	if global_position.x < -300:
		queue_free()
