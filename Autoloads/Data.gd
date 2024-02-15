extends Node2D

var pipeQueue : Array[Pipe] = []

var nextPipePosition := Vector2(1200, 300)

func _physics_process(delta: float) -> void:
	if (pipeQueue.size() > 0):
		if (pipeQueue[0].global_position.x < 60):
			pipeQueue.pop_front()
		nextPipePosition = pipeQueue[0].global_position
		print(nextPipePosition)

func queuePipe(pipe: Pipe):
	pipeQueue.push_back(pipe)
