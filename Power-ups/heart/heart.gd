extends Node2D


var velocity:int = 200
var current_cell:int = 0
const size_cell:int = 120

var name_key:String = "heart"

@onready var tree:Node2D = $"../.."



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_position:float = 120+(current_cell*240)
	position.y = lerp(position.y, true_position, 15*delta)
func _ready() -> void:
	tree.updateFrame.connect(next_frame)
	
func next_frame() -> void:
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)

func get_cell_x() -> int:
	return int((position.x-60)/120)

func get_bonifier() -> int: return 3
