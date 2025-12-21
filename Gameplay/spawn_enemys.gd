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
	event_times_revision()
	camera_event()
	update_laser()
	if randi_range(0, 10) > spawn_probability: return
	if randi_range(0, 100) == 1:
		return
	spawn()
	for i in get_children():
		if i.current_cell == 5:
			i.queue_free()

const Minimum_interval_between_events:int = 10
func event_times_revision()-> void:
	var cooldawn_camera_event:int = 100 - ($"..".frame_number % 100) 
	var cooldawn_laser_event:int = laser_frame_cooldawn

	if abs(cooldawn_camera_event - cooldawn_laser_event) < Minimum_interval_between_events:
		laser_frame_cooldawn += 25

func clear_enemys(except:int=-1) -> void:
	for children in get_children():
		if children.get_cell_x() == except: continue
		children.queue_free()




var laser_frame_cooldawn:int = 30

var laser_activated:bool = false
func update_laser() -> void:
	laser_frame_cooldawn -= 1
	
	if laser_frame_cooldawn == 2 or laser_frame_cooldawn == 1:
		$"../Laser/AnimationPlayer".play("Laser")
		clear_enemys()
		active = false

	elif laser_frame_cooldawn == 3:tree.inmortality_cooldawn += 2

	elif laser_frame_cooldawn == 0:
		$"../Laser/Laser/AnimationPlayer".play("laser")
		laser_activated = true

	elif laser_frame_cooldawn == -1:
		laser_activated = false
		active = true
		laser_frame_cooldawn = randi_range(20, 50)

var _camera_event_active:bool = false
func get_camera_event_state() -> bool:
	return _camera_event_active
func camera_event() -> void:
	if $"..".frame_number % 100 == 0:
		$"../Camera2D/AnimationPlayer".play("camera_event_start")
		_camera_event_active = true
		laser_frame_cooldawn += 25
	elif $"..".frame_number % 125 == 0:
		$"../Camera2D/AnimationPlayer".play("camera_event_end")
		_camera_event_active = false
	else: return
	clear_enemys()


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

var enemies_weights:Array[int] =[1000,500,225,550,550,175,    20,30,30    ,100, 100, 15, 5, 5, 1]


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
