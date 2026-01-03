extends Enemy_class


var name_key:String = "heart"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position(delta)
func _ready() -> void:
	tree.updateFrame.connect(next_frame)
	danger = false
	setup()
func next_frame() -> void:
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)

func get_bonifier() -> int: return 3
