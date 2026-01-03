extends Enemy_class

var name_key:String = "ghost fire"


var modulate_objetive:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)
	modulate.a = lerpf(modulate.a, modulate_objetive, delta*4)
func _ready() -> void:
	setup()
	efect_dead_active()
	tree.updateFrame.connect(next_frame)
	modulate.a = 0

func next_frame() -> void:
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)
	modulate_objetive = clampf(current_cell, 0, 4) / 4.0

	check_dead()
