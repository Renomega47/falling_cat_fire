extends Enemy_class

var name_key:String = "explosive fire"


func _process(delta: float) -> void:
	update_position(delta)

func _ready() -> void:
	efect_dead_active()
	setup()
	tree.updateFrame.connect(next_frame)

func next_frame() -> void:
	current_cell += 1
	if current_cell == 2:
		$"..".clear_enemys(get_cell_x())
		for i in [clamp(get_cell_x()-1, 0, 5), get_cell_x(),clamp(get_cell_x()+1, 0, 5)]:
			var object_instance:Node2D
			object_instance = $"..".enemies[10].instantiate()
			object_instance.global_position = Vector2(60+(i*120), -200)
			object_instance.current_cell = 3
			object_instance.anim_boom_play()
			$"..".add_child(object_instance)
		anim_boom_play()

		for i in $"..".get_children():
			if i.get_cell_x() != get_cell_x():
				i.current_cell = 2
	current_cell = clampi(current_cell, 0, 5)

	check_dead()




func anim_boom_play() -> void:
	$Node2D/AnimExplosion.play("boom")
