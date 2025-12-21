extends Control



func _ready() -> void:
	for name_key in Global.save["achievements"]:
		for children in $GridContainer.get_children():
			if children.name != name_key:continue
			children.get_child(0).modulate = Color(1,1,1,1)
			children.get_child(3).visible = false
