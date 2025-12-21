extends Enemy_class

var name_key:String = "speed fire"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_position:float = 120+(current_cell*240)
	position.y = lerp(position.y, true_position, 15*delta)
func _ready() -> void:
	efect_dead_active()
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	current_cell += 2
	current_cell = clampi(current_cell, 0, 5)
	check_dead()
func get_cell_x() -> int:
	return int((position.x-60)/120)
