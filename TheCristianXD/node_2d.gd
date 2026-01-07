extends Node2D


func _on_button_pressed() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("moveUp")

func _on_button_2_pressed() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("moveUpDownInstant")

func _on_button_3_pressed() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("moveH")
