extends Node

@onready var pipeSpawner := $PipeSpawner
@onready var trainer := $Trainer

func _on_HUD_start() -> void:
	trainer.init()
	trainer.prepare_next_generation()


func _on_trainer_next_generation_ready() -> void:
	Events.start_generation.emit()
	UiEvents.next_generation.emit()
	pipeSpawner.start()


func _on_trainer_generation_ended() -> void:
	Events.end_generation.emit()
	pipeSpawner.end()
	trainer.prepare_next_generation()

