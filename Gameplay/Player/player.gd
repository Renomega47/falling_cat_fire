extends Node2D

var previous_cell:int

const size_cell:int = 120
var current_cell:int = 0
@onready var Game:Node2D = $".."

@onready var spawn_enemy:Node2D = $"../Spawn enemy"
@onready var especials_events:Node2D = $"../Especials Events"

var current_cell_y:int = 4

var jumping:bool = false

signal player_update
signal player_update_last_comprobations

var cooldawn_update_previous_cell:float
const cooldawn_update_previous_cell_max:float = 0.03

func _ready() -> void:
	Game.updateFrame.connect(frame_next)
	frame_next()

var _pending_input:int = 0
func _get_pending_input(axis:int) -> int:
	if axis != 0: 
		_pending_input = 0
		return axis
	var return_input:int = _pending_input
	_pending_input = 0
	return return_input
func _process(delta: float) -> void:
	var true_position_X:float = current_cell * size_cell
	position.x = lerp(position.x, true_position_X, 12*delta)

	var true_position_Y:float = 120+(current_cell_y*240)
	position.y = lerp(position.y, true_position_Y, 12*delta)

	if Game.play == false:return
	_evaluate_hability()
	
	var temp_axis:int = get_axis()
	if move_cooldawn <= 0 and temp_axis != 0:
		move_cell(_get_pending_input(temp_axis))
	else: _pending_input = temp_axis
	move_cooldawn-=delta
	cooldawn_update_previous_cell-=delta
	if cooldawn_update_previous_cell <= 0:
		previous_cell = current_cell
		cooldawn_update_previous_cell = cooldawn_update_previous_cell_max

func get_axis() -> int:
	var input:int = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	if especials_events.get_camera_event_state():
		return -input 
	return input



func get_jump_axis() -> bool:
	return Input.is_action_pressed("jump")

func get_hability_axis() -> bool:
	return Input.is_action_pressed("hability")



#region jump var
var frame_cooldawn:int 
var frame_cooldawn_max:int = 2
#endregion

func frame_next() -> void:
	#region jump
	if get_jump_axis() and frame_cooldawn <= 0 and especials_events.active_duration >= 1:
		jumping = true
		frame_cooldawn = frame_cooldawn_max
		move_cooldawn = frame_cooldawn_max
		$Sprites/AnimationPlayer2.play("moveUp")
	elif frame_cooldawn <= 0:
		jumping = false

	elif jumping == true:
		frame_cooldawn -= 1
		move_cooldawn = move_cooldawn_max
	#endregion


var move_cooldawn:float = 0
var move_cooldawn_max:float = 0.2


func move_cell(axis:int) -> void:
	var cell_temp:int = current_cell
	current_cell += axis

	if cell_temp != current_cell: 
		previous_cell = cell_temp
		cooldawn_update_previous_cell = cooldawn_update_previous_cell_max
#INFO Move Animation
		$"Sprites/Player sprite".scale.x = clampi(current_cell-cell_temp, -1, 1) 
		$Sprites/AnimationPlayer2.play("RESET")
		$Sprites/AnimationPlayer2.play("moveH")


	current_cell = clampi(current_cell, 0, 5)

	if axis != 0: 
		move_cooldawn = move_cooldawn_max
		player_update.emit()
		player_update_last_comprobations.emit()


func _evaluate_hability() -> void:
	if not move_cooldawn <= 0: return
	$Habilitys.check_instant_hability()
	if get_hability_axis() and $Habilitys.activatable():
		$Habilitys.active_hability()
		player_update.emit()
		player_update_last_comprobations.emit()
