extends Node2D


signal updateFrame
signal finalFrame
var cooldawn:float
var cooldawn_max:float = 0.4

var play:bool = false

var inmortality_cooldawn:int = 0

@onready var spawn_enemy:Node2D = $"Spawn enemy"
@onready var especials_events:Node2D = $"Especials Events"
@onready var player:Node2D = $Player
var perfect_dodges_counting:int = 0


func _ready() -> void:
	Global.load_option()
	update_player_size_increment()
	if Global.dificult_max: 
		cooldawn_max = 0.4
	else: 
		cooldawn_max = 0.6
	play = true
	resset_temporizer()
	updateFrame.connect(next_frame)
	finalFrame.connect(frame_fase_final)
	Global.achievement_complete.connect(achivement_notification)



func _process(delta: float) -> void:
	temporizer(delta)


func lines_debug() -> void:
	for i in 6:
		$"lines debug".get_children()[i].position.x = i*120

#region frames controller
func resset_temporizer() -> void:
	cooldawn = cooldawn_max


func temporizer(delta:float) -> void:
	if play == false:
		return
	if cooldawn <= 0:
		cooldawn = cooldawn_max
		updateFrame.emit()
		finalFrame.emit()
	cooldawn -= delta

#endregion

#region puntuation controller
var puntuation:int

func next_frame() -> void:
	if inmortality_cooldawn > 0: inmortality_cooldawn -= 1
	if inmortality_cooldawn == 0: 
		inmortality_cooldawn = -1
		$Player/Habilitys/Habilitys_anim.play("RESET")

	_evaluate_perfect_dodge()
	puntuation += 1
	idle_time += 1
	if idle_time > 15: Global.add_to_achievements("The Waiting Game")
	$Label.text = str(puntuation)


func text_bonus_spawn() -> void:
	var scene:PackedScene = load("res://Gameplay/UI/Text_perfect.tscn")
	var instance:Control = scene.instantiate()
	$Player/Mensajes.add_child(instance)

func get_bonus() -> bool:
	for enemy in spawn_enemy.get_children():
		if not $Player.previous_cell == enemy.get_cell_x(): continue

		if enemy.name_key == "speed fire":
			if enemy.current_cell == 2: return true
			else:continue
		elif enemy.name_key == "slow fire":
			if enemy.cooldawn == 0 and enemy.current_cell == 3: return true
			else:continue

		if enemy.current_cell == 3:
			return true
	return false
#endregion

func save_puntuation() -> void:
	var key:Array[String] = ["max_puntuation_normal" ,"max_puntuation_hard"]
	if Global.save [key[int(Global.dificult_max)]] < puntuation:
		Global.save[key[int(Global.dificult_max)]] = puntuation
		Global.save_game()

	$Label.text = str(puntuation)

func frame_fase_final() -> void:
	$CanvasLayer/Container.release_inputs()
	_dead()

	_power_up()


func check_achievements() -> void:
	const objects:Array[String] = ["heart","left arrow","right arrow","fire", "pink fire", "green fire", "ghost fire", "speed fire", "fire variant", "explosive fire", "slow fire", "doppelcat", "green cat" ,"orange cat", "cat"]
	if count_matching_elements(Global.save["codex"], objects) >= 6: Global.add_to_achievements("Archaeologist 1")
	if count_matching_elements(Global.save["codex"], objects) >= 12: Global.add_to_achievements("Archaeologist 2")
	if count_matching_elements(Global.save["codex"], objects) >= 15: Global.add_to_achievements("Archaeologist 3")

	if Global.save["max_puntuation_normal"] >= 2690 or Global.save["max_puntuation_hard"] >= 1924:
		Global.add_to_achievements("Better Than the Devs")
	if Global.save["max_puntuation_normal"] >= 9554 or Global.save["max_puntuation_hard"] >= 6323:
		Global.add_to_achievements("Noodle Nemesis")

	if perfect_dodges_counting > 50: Global.add_to_achievements("Perfect Dodge Master")


func count_matching_elements(container_array: Array, items_to_check: Array) -> int:
	var match_count: int = 0
	for item in items_to_check:
		if container_array.has(item): match_count += 1
	return match_count


func bonus_laser() -> void:
	puntuation += 20
	perfect_dodges_counting += 1
	text_bonus_spawn()

func check_defeat() -> bool:
	if inmortality_cooldawn > 0:
		return false

#condition 1
	if especials_events.died_from_event(): return true

#condition 2
	for i in $"Spawn enemy".get_children():
		if i.has_method("get_bonifier"): continue
		if i.danger == false: continue
		if (i.current_cell == $Player.current_cell_y) and i.get_cell_x() == $Player.current_cell:
			#achievement
			if i.name_key == "explosive fire":Global.add_to_achievements("I'm Cree Bumm")

			return true

	return false

func check_bonifier_objects() -> int:
	var bonifier_key:int = 0
	for i in $"Spawn enemy".get_children():
		if i.current_cell != $Player.current_cell_y or i.get_cell_x() != $Player.current_cell:
			continue

		if i.has_method("get_bonifier"): 
			bonifier_key = i.get_bonifier() 
			i.queue_free()


	return bonifier_key
#region menu
func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_go_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Menu.tscn")

var texture:Array[Texture2D] = [load("res://Power-ups/right/right icon.png"),load("res://Power-ups/left/left icon.png"),load("res://Power-ups/heart/healt.png")]
func update_power_up() -> void:
	if $Player/Habilitys.hability_key == 0:
		$Sprite0002/power_up.texture = null
		return
	$Sprite0002/power_up.texture = texture[$Player/Habilitys.hability_key-1]

func change_colors() -> void:
	var colors:Array = [
		Color("e9ba87ff"),
		Color("01d5ffff"),
		Color("a283cdff"),
		Color("717affff"),
		Color("ff00ff"),
		Color("73ff00ff"),
	]
	var color:Color = colors[randi_range(0,5)]
	$Sprite0002.self_modulate = color
	$Camera2D/lightDown.self_modulate = color
	$Camera2D/lightUp.self_modulate = color
	$CPUParticles2D.self_modulate = color

func achivement_notification(text:String) -> void:
	var scene:PackedScene = load("res://Gameplay/UI/Achievement Text.tscn")
	var instance:CanvasLayer = scene.instantiate()
	instance.set_text(text)
	$Achievements.add_child(instance)

#endregion



func _dead() -> void:
	await get_tree().create_timer(0.09).timeout
	if check_defeat() == true:
		save_puntuation()
		check_achievements()

		play = false
		$CanvasLayer/Dead/AnimationPlayer.play("DEAD")
		for i in $Player/Mensajes.get_children():i.queue_free()
		Global.save_game()

func _power_up() -> void:
	var power_up_key:int = check_bonifier_objects()
	if power_up_key == 0: return
	$Player/Habilitys.hability_key = power_up_key
	update_power_up()

func _evaluate_perfect_dodge() -> void:
	if get_bonus():
		puntuation += 20
		perfect_dodges_counting += 1
		text_bonus_spawn()

var idle_time:int
func checks() -> void:
	idle_time = 0
	_power_up()
	_evaluate_perfect_dodge()


func update_player_size_increment() -> void:
	if Global.options["player_size_increment"]:
		$Player/Sprites.position = Vector2.ZERO
		$Player/Sprites.scale = Vector2(1,1)
	else:
		$Player/Sprites.position = Vector2(12,24)
		$Player/Sprites.scale = Vector2(0.8,0.8)
