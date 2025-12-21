extends Node2D


signal visible_change
signal not_danger


func _visible_change_emit() -> void:
	visible_change.emit()

signal dead

func _dead_emit() -> void:
	dead.emit()

func _not_danger_emit() -> void:
	not_danger.emit()

func play_animation() -> void:
	$AnimationPlayer.play("boom")
