class_name ScoreUp
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Bird:
		body.score += 1
