extends Control

var hard:bool = false

const CALIFICATIONS_HARD: Array = [
	["[rainbow][wave]FLYING    SPAGHETTI[/wave][font_size=32]   Monster[/font_size][/rainbow]", 9999],
	["[wave][rainbow]SPAGHETTI CAT", 6323],
	["[color=purple][wave]RENOMEGA47", 474],
	["[color=blue][wave]ZETAR", 876],
	["[wave][color=green]CRISTIAN  10", 4153]
]
const CALIFICATIONS_EASY: Array = [
	["[wave][rainbow]SPAGHETTI CAT", 9554],
	["[color=purple][wave]RENOMEGA47", 1924],
	["[color=blue][wave]ZETAR", 2690],
	["[color=green][wave]LUIGGI", 937],
	["[wave][color=green]CRISTIAN  10", 5540]
]




func _ready() -> void:
	update_puntuation()
	update_button_textures()

func update_puntuation() -> void:

	var temp_array:Array
	if hard: 
		temp_array = CALIFICATIONS_HARD.duplicate()
		temp_array.append(["[wave][color=cyan]YOU", Global.save["max_puntuation_hard"]])
	else: 
		temp_array = CALIFICATIONS_EASY.duplicate()
		temp_array.append(["[wave][color=cyan]YOU", Global.save["max_puntuation_normal"]])
	
	var order_array:Array = get_order(temp_array)
	
	var children_key:int = 0
	for i in order_array:
		$VBoxContainer.get_children()[children_key].get_children()[1].text = temp_array[i][0]
		$VBoxContainer.get_children()[children_key].get_children()[2].text = str(temp_array[i][1])
		children_key += 1

func separated(array:Array) -> Array:
	var return_array:Array[int]
	for i in array:
		return_array.append(i[1])
	return return_array

 
func get_order(array:Array) -> Array[int]:
	var temp_array:Array = array.duplicate()
	temp_array = separated(temp_array)
	
	
	var array_return:Array[int] =[]
	for i in range(1 ,temp_array.size()+1):
		array_return.append(get_number(temp_array, i))
	return array_return


func get_number(array: Array, key: int) -> int:
	var used_indices = []
	var key_temp = -1
	
	for n in range(key):
		key_temp = -1
		for i in range(array.size()):
			if i in used_indices:
				continue
			if key_temp == -1 or array[i] > array[key_temp]:
				key_temp = i
		used_indices.append(key_temp)
	
	return key_temp  # devuelve el índice del key-esimo número más grande


@onready var dificult_button:Array = [$Easy, $Hard]
func update_button_textures() -> void:
	dificult_button[0].disabled = hard
	dificult_button[0].visible = !hard
	dificult_button[1].disabled = !hard
	dificult_button[1].visible = hard
func change_dificult() -> void:
	hard = !hard
	_ready()
