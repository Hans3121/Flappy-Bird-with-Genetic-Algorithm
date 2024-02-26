extends Node2D

var pipeQueue : Array[Pipe] = []

var nextPipePosition := Vector2(1200, 300)

func _ready() -> void:
	Events.end_generation.connect(func(): pipeQueue = [])

func _physics_process(delta: float) -> void:
	if (pipeQueue.size() > 0):
		nextPipePosition = pipeQueue[0].global_position
		if (pipeQueue[0].global_position.x < 60):
			pipeQueue.pop_front()


func queuePipe(pipe: Pipe):
	pipeQueue.push_back(pipe)
