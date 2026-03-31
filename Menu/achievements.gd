extends Control



func _ready() -> void:
	for name_key in Global.save["achievements"]:
		for children in $GridContainer.get_children():
			if children.name != name_key:continue
			children.get_child(0).modulate = Color(1,1,1,1)
			children.get_child(3).visible = false

	update_page()
var next_page:bool = false

const max_per_page = 6
func update_page() -> void:
	var childs:Array[Node] = $GridContainer.get_children()
	for i in childs.size():
		if i < max_per_page: childs[i].visible = !next_page
		else: childs[i].visible = next_page

	$Back.disabled = !next_page
	$Back.visible = next_page

	$Next.disabled = next_page
	$Next.visible = !next_page



func _pressed_button() -> void:
	next_page = !next_page
	update_page()
