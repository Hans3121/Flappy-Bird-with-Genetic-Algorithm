extends CanvasLayer

signal start

@onready var score_label = $Score
@onready var generation_label = $Generation

var score = 0
var generation = 0


func update_score(_score: int):
	score = _score
	score_label.text = "Score : " + str(score)


func update_generation():
	generation += 1
	generation_label.text = "Generation : " + str(generation)


func _ready() -> void:
	update_score(0)
#	UiEvents.scoreChanged.connect(update_score)
	UiEvents.increment_score.connect(func(): update_score(score+1))
	UiEvents.next_generation.connect(update_generation)
	Events.end_generation.connect(update_score.bind(0))


func _start():
	$Title.hide()
	$PlayButton.hide()
	$FeatureSelection.hide()
	emit_signal("start")

func end():
	$Title.show()
	$PlayButton.show()

