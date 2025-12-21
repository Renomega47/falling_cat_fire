extends Control

func _on_yes_pressed() -> void:
	Global.reset_save()
	Global.reset_option()
	get_tree().reload_current_scene()

func _ready() -> void:
	Global.load_option()
	$CheckBox.button_pressed = Global.options["player_size_increment"]


func _on_no_pressed() -> void:
	$Popup.visible = false




func _on_delete_save_pressed() -> void:
	$Popup.visible = true


func _on_watch_tutorial_pressed() -> void:
	$"../Tutorial".visible = true


func _on_check_box_toggled(toggled_on: bool) -> void:
	Global.options["player_size_increment"] = toggled_on
	Global.save_option()
