extends Node

var dificult_max:bool = false


var save:Dictionary ={
	"max_puntuation_hard":0,
	"max_puntuation_normal":0,
	"codex":[],
	"achievements":[]
}

var options:Dictionary ={
	"player_size_increment":false
}
#"fire", "pink fire", "green fire", "ghost fire", "speed fire", "fire variant, "explosive fire", "slow fire", "doppelcat", "orange cat", "cat"
const save_path:String = "user://save_game.dat"
const option_path:String = "user://option.dat"
func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(save)
	save_file = null

func load_game() -> void:
	if !FileAccess.file_exists(save_path):
		return

	var save_file = FileAccess.open(save_path, FileAccess.READ)
	save = save_file.get_var()
	save_file = null

func reset_save() -> void:
	save = {
	"max_puntuation_hard":0,
	"max_puntuation_normal":0,
	"codex":[],
	"achievements":[]}
	save_game()

func save_option() -> void:
	var save_file = FileAccess.open(option_path, FileAccess.WRITE)
	save_file.store_var(options)
	save_file = null

func load_option() -> void:
	if !FileAccess.file_exists(option_path):
		return

	var save_file = FileAccess.open(option_path, FileAccess.READ)
	options = save_file.get_var()
	save_file = null

func reset_option() -> void:
	options={"player_size_increment":false}
	save_option()

signal achievement_complete(name_achievement:String)
func add_to_achievements(name_achievement:String) -> void:
	if !Global.save["achievements"].has(name_achievement):
		Global.save["achievements"].append(name_achievement)
		achievement_complete.emit(name_achievement)
