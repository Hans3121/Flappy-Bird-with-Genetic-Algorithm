class_name Bird
extends RigidBody2D

@export var jumpPower := -200

var score := 0 : set = _set_score

func _set_score(newScore: int):
	score = newScore
	UiEvents.scoreChanged.emit(newScore)

signal died(score: int, weights: Array[float])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	body_shape_entered

func start():
	freeze = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		linear_velocity.y = jumpPower

func die():
	died.emit(score, [])
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Pipes:
		die()

