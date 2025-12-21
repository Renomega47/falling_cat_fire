extends Enemy_class

var name_key:String = "ghost fire"


var modulate_objetive:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_position:float = 120+(current_cell*240)
	var velocity_modulete:int = 30 if Global.dificult_max else 15
	position.y = lerp(position.y, true_position, velocity_modulete*delta)
	modulate.a = lerp(modulate.a, modulate_objetive, delta)
func _ready() -> void:
	efect_dead_active()
	tree.updateFrame.connect(next_frame)
	modulate.a = 0

func next_frame() -> void:
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)
	modulate_objetive = clampf(current_cell, 0, 4)/4 
	check_dead()

func get_cell_x() -> int:
	return int((position.x-60)/120)
