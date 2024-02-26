class_name Bird
extends RigidBody2D

signal died(score: int, weights: Array[float])

@export var jumpPower := -1000

var score := 0 : set = _set_score
var weights = []

func _ready() -> void:
	Events.start_generation.connect(func():
		set_deferred("freeze", false))
	set_deferred("freeze", true)


func _set_score(newScore: int):
	score = newScore
#	UiEvents.scoreChanged.emit(newScore)

func _physics_process(_delta: float) -> void:
	if (should_jump()):
		linear_velocity.y = jumpPower

# Predictor function
func should_jump() -> bool:
	var x = (Data.nextPipePosition.x - global_position.x)
	var y = (Data.nextPipePosition.y - global_position.y)
	var value = 0

	for i in range(Config.selected_features.size()):
		var tmp = weights[i]
		match (Config.selected_features[i].type):
			0:
				tmp *= 1
			1:
				tmp *= x
			2:
				tmp *= y
			3:
				tmp *= x**2
			4:
				tmp *= y**2
			5:
				tmp *= sqrt(x**2 + y**2)
			6:
				tmp *= linear_velocity.y
			_:
				tmp = 0
		value += tmp


	if (signf(value) == 1): return true
	else: return false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Pipe"):
		died.emit(score, weights)
		queue_free()

