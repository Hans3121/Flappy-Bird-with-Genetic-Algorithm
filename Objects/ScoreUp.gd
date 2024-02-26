class_name ScoreUp
extends Area2D

var has_been_passed := false

func _on_body_entered(body: Node2D) -> void:
	if body is Bird:
		body.score += 1
	if not has_been_passed:
		has_been_passed = true
		UiEvents.increment_score.emit()
