extends CanvasLayer


func set_text(name_achievement:String) -> void:
	$ColorRect/TextPerfect.text = "Unlocked: " + "“" + name_achievement + "”"
