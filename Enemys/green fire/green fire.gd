extends Enemy_class

var name_key:String = "green fire"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)
func _ready() -> void:
	efect_dead_active()
	setup()
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	current_cell += 1
	if current_cell == 3:
		var next_cell:int = clampi(get_cell_x()-1,0,5)
		set_cell_x(next_cell)
	current_cell = clampi(current_cell, 0, 5)
	check_dead()
