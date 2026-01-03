extends Node

var _instant_habilitys:Array[int] = [3]
func check_instant_hability() -> void:
	for i in _instant_habilitys:
		if hability_key == i: 
			active_hability()
			return

var hability_key = 0
func active_hability():
	call("_hability_"+str(hability_key))
	hability_key = 0
	$"../..".update_power_up()
	$AudioStreamPlayer2D.play()

func activatable() -> bool:
	return bool(hability_key) 

func _hability_1()-> void:
	$"..".move_cell(3)

func _hability_2()-> void:
	$"..".move_cell(-3)

func _hability_3()-> void:
	$"../..".inmortality_cooldawn = 15
	$Habilitys_anim.play("3")
