extends Node

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
	$"../..".inmortality_cooldawn = 10
	$Habilitys_anim.play("3")
