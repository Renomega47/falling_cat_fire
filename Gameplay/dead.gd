extends Node
func _ready() -> void:set_process(false)


var new_record:bool = false
func play_anim_new_record() -> void:
	if new_record == false:return
	set_process(true)
	var key:Array[String] = ["max_puntuation_normal" ,"max_puntuation_hard"]
	number = Global.save[key[int(Global.dificult_max)]]
	$"Record Text".visible = true


var number:int
var temp_number:float
var speed:float = 2
func _process(delta: float) -> void:
	temp_number = lerpf(temp_number, number, speed*delta)
	var text:String = "[rainbow]"+str(int(temp_number)+1)
	if _absolute_distance(temp_number, number) < 100:
		speed = lerpf(speed, 1, delta)
	if $"Record Text/Record".text != text:$"Record Text/AudioStreamPlayer".play()
	$"Record Text/Record".text = text
	if _absolute_distance(temp_number, number) < 0.5: 
		$"Record Text/AnimationPlayer".play("fisish")
		set_process(false)

func _absolute_distance(a:float, b:float) -> float:
	return abs(a-b)
