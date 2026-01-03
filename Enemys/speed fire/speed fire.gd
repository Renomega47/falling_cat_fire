extends Enemy_class

var name_key:String = "speed fire"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)
func _ready() -> void:
	efect_dead_active()
	setup()
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	current_cell += 2
	current_cell = clampi(current_cell, 0, 5)
	check_dead()
