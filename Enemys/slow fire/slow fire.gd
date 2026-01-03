extends Enemy_class

var name_key:String = "slow fire"


var cooldawn:int
const max_cooldawn:int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)

func _ready() -> void:
	efect_dead_active()
	setup()
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	if cooldawn > 0:
		cooldawn -= 1
		return
	cooldawn = max_cooldawn
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)
	check_dead()
