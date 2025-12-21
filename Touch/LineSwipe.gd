extends Line2D
class_name LineSwipe

var queue: Array
var MAX_LENGTH:int = 10
var active:bool = false

func resetLine() -> void:
	clear_points()
	queue = []

func update() -> void:
	if active == false:
		return
	var pos = get_global_mouse_position()
	
	queue.push_front(pos)
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	clear_points()
	
	for point in queue:
		add_point(point)
