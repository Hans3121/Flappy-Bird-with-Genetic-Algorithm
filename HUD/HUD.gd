extends CanvasLayer

signal start

func update_score(score: int):
	$Score.text = "Score : " + str(score)

func _ready() -> void:
	UiEvents.scoreChanged.connect(update_score)

func _start():
	$Title.hide()
	$PlayButton.hide()
	emit_signal("start")

func end():
	$Title.show()
	$PlayButton.show()
