extends Enemy_class

var name_key:String = "green cat"

var true_position_x:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_position:float = 120+(current_cell*240)
	position.y = lerp(position.y, true_position, 15*delta)
	position.x = lerp(position.x, true_position_x, 15*delta)
func _ready() -> void:
	efect_dead_active()
	true_position_x = position.x
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	current_cell += 1
	if current_cell == 3:
		var next_cell:int = clampi(get_cell_x()-1,0,5)
		true_position_x = 60+(next_cell*120)
	current_cell = clampi(current_cell, 0, 5)

	check_dead()

func get_cell_x() -> int:
	return int((true_position_x-60)/120)
