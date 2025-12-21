extends Enemy_class

var name_key:String = "doppelcat"


var change:bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var true_position: float = 120 + (current_cell * 240)
	position.y = lerp(position.y, true_position, 15 * delta)
	if change == false:return
	texture.modulate.a = lerp(texture.modulate.a, 1.0, delta*4)
	$Sprite2D.modulate.a = 1.0 - texture.modulate.a

var sprites:Array[Texture2D] = [load("res://Enemys/speed fire/blue(fast).png"), load("res://Enemys/explosive fire/orange(esplosive) XD referencia .png"), load("res://Enemys/pink fire/pink(right).png"), load("res://Enemys/green fire/green(left).png")]
func _ready() -> void:
	efect_dead_active()
	$Sprite2D.texture = sprites[randi_range(0, sprites.size()-1)]
	$Sprite2D.modulate.a = 1
	texture.modulate.a = 0
	tree.updateFrame.connect(next_frame)


func next_frame() -> void:
	if current_cell == 1:
		change = true
	current_cell += 1
	current_cell = clampi(current_cell, 0, 5)
	check_dead()

func get_cell_x() -> int:
	return int((position.x-60)/120)
