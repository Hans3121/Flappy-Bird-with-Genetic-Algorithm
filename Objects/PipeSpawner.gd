extends Node2D

@export var pipes : PackedScene
@export var pipeSpeed := 150

@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


func start() -> void:
	timer.start()
	_spawn_pipe()

func end() -> void:
	timer.stop()


func _on_Timer_timeout() -> void:
	_spawn_pipe()

func _spawn_pipe() -> void:
	var pipe = pipes.instantiate()
	add_child(pipe)

	Data.queuePipe(pipe)
	pipe.speed = pipeSpeed
	pipe.position.y += randf_range(-200, 200)
