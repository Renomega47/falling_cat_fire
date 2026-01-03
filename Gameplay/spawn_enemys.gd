extends Node2D

var spawn_probability:int = 7

var active:bool = true

@onready var tree:Node2D = $".."
func _ready() -> void:
	tree.updateFrame.connect(frame_next)

func spawn(force_key:int=-1) -> void:
	if active == false:return
	var point_key:int = randi_range(0, 5)
	var object_instance:Node2D 
	if force_key == -1:
		object_instance = enemies[get_random_enemy_key()].instantiate()
	else: object_instance = enemies[force_key].instantiate()

	add_to_bestiary(object_instance)
	object_instance.global_position = Vector2(60+(point_key*120), -200)
	add_child(object_instance)

func frame_next() -> void:
	if randi_range(0, 10) > spawn_probability: return
	if randi_range(0, 100) == 1:
		return
	spawn()
	for i in get_children():
		if i.current_cell == 5:
			i.queue_free()


func clear_enemys(except:int=-1) -> void:
	for children in get_children():
		if children.get_cell_x() == except: continue
		if not children.has_method("check_dead"):
			children.queue_free()
			continue
		if children.dead_node == null: 
			children.queue_free()
			continue
		children.check_dead(true)


func add_to_bestiary(monster:Node2D) -> void:
	if !Global.save["codex"].has(monster.name_key):
		Global.save["codex"].append(monster.name_key)



var enemies:Array[PackedScene] = [
load("res://Enemys/fire/fire.tscn"),
load("res://Enemys/ghost fire/ghost fire.tscn"),
load("res://Enemys/speed fire/speed fire.tscn"), 
load("res://Enemys/green fire/green fire.tscn"),
load("res://Enemys/pink fire/pink fire.tscn"),
load("res://Enemys/slow fire/slow fire.tscn"),#5

load("res://Power-ups/heart/heart.tscn"),
load("res://Power-ups/left/left.tscn"),
load("res://Power-ups/right/right.tscn"),#8

load("res://Enemys/doppelcat/doppelcat.tscn"),#9
load("res://Enemys/explosive fire/explosive fire.tscn"), #explosive cat
load("res://Enemys/fire variant/fire variant.tscn"),
load("res://Enemys/cat/green cat.tscn"),
load("res://Enemys/cat/orange cat.tscn"),
load("res://Enemys/cat/cat.tscn")]

var enemies_weights:Array[int] =[1000,250,225,675,675,175,    20,30,30    ,100, 100, 15, 5, 5, 1]
#var enemies_weights:Array[int] =[0,0,0,0,0,0,    1,0,0    ,0, 0, 0, 0, 0, 0]

func get_random_enemy_key() -> int: #weights sistem

	assert(enemies.size() == enemies_weights.size())

	var total_weight:int = 0
	for weight in enemies_weights:
		total_weight += weight

	var roll:int = randi() % total_weight
	var cumulative:int = 0

	for i in range(enemies_weights.size()):
		cumulative += enemies_weights[i]
		if roll < cumulative:
			return i

	return 0
