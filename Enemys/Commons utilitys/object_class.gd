extends Node2D
class_name Enemy_class

@onready var tree:Node2D = get_parent().get_parent()
@export var texture:Sprite2D
@export var dead_node:Node2D
var danger:bool = true


var velocity:int = 200
var current_cell:int = 0
const size_cell:int = 120



func efect_dead_active() -> void:
	dead_node.dead.connect(queue_free)
	dead_node.not_danger.connect(change_danger)
	dead_node.visible_change.connect(change_visibility)


func check_dead() -> void:
	if dead_node == null: return
	if current_cell == 4: 
		dead_node.play_animation()
		texture.position.y = 19

func change_visibility() -> void:
	texture.visible = false
func change_danger() -> void:
	danger = false
