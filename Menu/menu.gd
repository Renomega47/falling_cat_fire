extends Control


func _ready() -> void:
	Global.load_game()
	Global.load_option()
	$"Puntuations/normal puntuation/Label2".text = "[wave]" +str(Global.save["max_puntuation_normal"])
	$"Puntuations/hard puntuation/Label2".text = "[wave][rainbow]"  +str(Global.save["max_puntuation_hard"])

var camera_position_objetive:int = 360
func  _process(delta: float) -> void:
	$Camera2D2.position.x = lerpf($Camera2D2.position.x, camera_position_objetive, delta*4)

func _on_quit_pressed() -> void:
	get_tree().quit()

var tutorial_state:bool = true

func _on_easy_pressed() -> void:
	if tutorial_state == true and not (Global.save["max_puntuation_hard"] != 0 or Global.save["max_puntuation_normal"] != 0):
		tutorial_state = false
		$Tutorial.visible = true
		return

	await_button()
	await get_tree().create_timer(1).timeout
	Global.dificult_max = false
	get_tree().change_scene_to_file("res://Gameplay/Game.tscn")

func _on_hard_pressed() -> void:
	if tutorial_state == true and not (Global.save["max_puntuation_hard"] != 0 or Global.save["max_puntuation_normal"] != 0):
		tutorial_state = false
		$Tutorial.visible = true
		return

	await_button()
	await get_tree().create_timer(1).timeout
	Global.dificult_max = true
	get_tree().change_scene_to_file("res://Gameplay/Game.tscn")

func await_button() -> void:
	for i in [$VBoxContainer/Hard, $VBoxContainer/Easy, $VBoxContainer/Quit, $Credits, $VBoxContainer/Codex, $VBoxContainer/Ranking]:
		i.disabled = true
		$"Button pressed".play("button pressed")


func _on_bestiary_pressed() -> void:
	if camera_position_objetive == 2880:
		camera_position_objetive = 4680
		$Bestiary._ready()
	else:
		camera_position_objetive = 2880

func _on_codex_pressed() -> void:
	if camera_position_objetive == 360:
		camera_position_objetive = 2880
		$Codex._ready()
	else:
		camera_position_objetive = 360

const expresion_key:Array[int] = [0,12,26,30]
func change_expresion_cat() -> void:
	$Sprite2D.frame = expresion_key[randi_range(0,3)]


func _on_credits_pressed() -> void:
	$Creditos.visible = true


func _on_ranking_button_pressed() -> void:
	if camera_position_objetive == 360:
		camera_position_objetive = -1800
	else:
		camera_position_objetive = 360

func _on_options_button_pressed() -> void:
	if camera_position_objetive == 360:
		camera_position_objetive = -3240
	else:
		camera_position_objetive = 360


@onready var change_color_objects:Array = [$CPUParticles2D, $CPUParticles2D3, $CPUParticles2D2, $CPUParticles2D4, $CPUParticles2D5]
func change_color_lights() -> void:
	var colors:Array = [
		Color("e9ba87ff"),
		Color("01d5ffff"),
		Color("a283cdff"),
		Color("717affff"),
		Color("ff00ff"),
		Color("73ff00ff"),
	]
	$Camera2D2/lightDown.self_modulate = colors[randi_range(0,5)]

	$Camera2D2/lightUp.self_modulate = $Camera2D2/lightDown.self_modulate
	for object in change_color_objects:
		object.modulate = $Camera2D2/lightDown.self_modulate


#func instantiateScreen() -> void:
	#var SL = preload("res://B/ScreenLoading/screen_loading.tscn").instantiate()
	#$CanvasLayer.add_child(SL)


func _on_achievements_pressed() -> void:
	if camera_position_objetive == 2880:
		camera_position_objetive = 6120
		$achievements._ready()
	else:
		camera_position_objetive = 2880
