extends Node2D

@export var pipes : PackedScene
@export var pipeSpeed := 150
@export var pipeHoleLength := 100
@export var pipeInterval := 2

@onready var timer = $Timer

var time_passed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = pipeInterval


func start() -> void:
	timer.start()
	_spawn_pipe()

func end() -> void:
	timer.stop()


func _on_Timer_timeout() -> void:
	_spawn_pipe()

func _spawn_pipe() -> void:
	var pipe = pipes.instantiate()
	add_child.call_deferred(pipe)

	Data.queuePipe(pipe)
	pipe.speed = pipeSpeed
	pipe.hole_size = pipeHoleLength
	pipe.position.y += randf_range(-200, 200)
