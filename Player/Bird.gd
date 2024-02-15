class_name Bird
extends RigidBody2D

signal died(score: int, weights: Array[float])

@export var jumpPower := -200

var score := 0 : set = _set_score
var weights = [0, 0]

func _set_score(newScore: int):
	score = newScore
	UiEvents.scoreChanged.emit(newScore)

func _physics_process(_delta: float) -> void:
	if (should_jump()):
		linear_velocity.y = jumpPower

# Predictor function
func should_jump() -> bool:
	var value := signf(
		weights[0] * (Data.nextPipePosition.x - global_position.x) +
		weights[1] * (Data.nextPipePosition.y - global_position.y)
	)

	if (value == 1): return true
	else: return false

func _on_body_entered(body: Node) -> void:
	if body is Pipe:
		died.emit(score, [])
		queue_free()

