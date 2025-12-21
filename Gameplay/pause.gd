extends CanvasLayer




func pause() -> void:
	get_tree().paused = true
	$".".visible = true
	$Button.disabled = false
	$"Go to menu".disabled = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	$Button.disabled = true
	$"Go to menu".disabled = true

func _on_go_to_menu_pressed() -> void:
	$"..".save_puntuation()
	Global.save_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")
