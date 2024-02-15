extends Node2D

@export var cloud : PackedScene
@export var cloudSpeed : int = 1
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(spawnCloud)


func spawnCloud() -> void:
	var child = cloud.instantiate()
	child.position.y = randi_range(0, 500)
	child.speed = cloudSpeed
	add_child(child)

