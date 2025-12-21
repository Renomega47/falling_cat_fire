extends Control



func _ready() -> void:
	for name_key in Global.save["codex"]:
		for children in $BoxContainer.get_children():
			if children.name != name_key:continue
			children.get_child(0).modulate = Color(1,1,1,1)
			children.get_child(2).visible = false
