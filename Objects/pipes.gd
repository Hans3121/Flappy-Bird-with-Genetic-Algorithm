class_name Pipe
extends Node2D


@export var speed := 0
@export var hole_size := 200

func _ready() -> void:
	Events.end_generation.connect(queue_free)
	$PipeUp.position.y = -hole_size/2
	$PipeDown.position.y = hole_size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= delta * speed
	if global_position.x < -300:
		queue_free()
