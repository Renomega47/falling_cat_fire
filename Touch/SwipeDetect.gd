extends Container

@export var globalActive: bool = true
@export var lineSwipe: LineSwipe

const SWIPE_THRESHOLD: float = 100.0
const MAX_TOUCH_TIME: float = 0.3

var touch_start_position: Vector2 = Vector2.ZERO
var touching_time: float = 0.0
var lineSwipeActive: bool = false
var swipe_finished: bool = false


func _process(delta: float) -> void:
	if not lineSwipeActive:
		return

	lineSwipe.update()
	touching_time += delta


	if touching_time >= MAX_TOUCH_TIME and not swipe_finished:
		swipe_finished = true
		_end_touch(touch_start_position, get_global_mouse_position())


func _gui_input(event: InputEvent) -> void:
	if not globalActive:
		return


	if event is InputEventScreenTouch:
		if event.pressed:
			lineSwipe.active = true
			touch_start_position = event.position
			lineSwipeActive = true
			touching_time = 0.0
			swipe_finished = false
		else:
			if not swipe_finished:
				swipe_finished = true
				_end_touch(touch_start_position, event.position)


	elif event is InputEventScreenDrag and lineSwipeActive and not swipe_finished:
		var distance:int = event.position.distance_to(touch_start_position)


		if distance >= SWIPE_THRESHOLD:
			swipe_finished = true
			_end_touch(touch_start_position, event.position)


func _end_touch(start: Vector2, end: Vector2) -> void:
	lineSwipe.active = false
	lineSwipeActive = false
	touching_time = 0.0
	lineSwipe.resetLine()
	_check_swipe_direction(start, end)


func _check_swipe_direction(start: Vector2, end: Vector2) -> void:
	var delta := end - start

	if delta.length() < SWIPE_THRESHOLD:
		return
	release_inputs()


	if abs(delta.x) > abs(delta.y):
		if delta.x > 0:
			Input.action_press("right")
		else:
			Input.action_press("left")

	# Vertical
	else:
		if delta.y < 0:
			Input.action_press("jump")
		else:
			Input.action_press("hability")


func release_inputs() -> void:
	Input.action_release("right")
	Input.action_release("left")
	Input.action_release("jump")
	Input.action_release("hability")

func release_mov_inputs() -> void:
	Input.action_release("right")
	Input.action_release("left")


func release_specials_inputs() -> void:
	Input.action_release("jump")
	Input.action_release("hability")
