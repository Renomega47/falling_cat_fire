extends Control

func Delete() -> void:
	queue_free()
	$"../Button".queue_free()


func _on_button_pressed() -> void:
	$"..".visible = false
