extends Node2D

var active:bool = true

#[Event name, min cooldawn, max cooldawn, Spawn Probability]
const events:Array[Array] = [ 
	["laserV1", 30, 60, 3],
	["flip_camera", 40, 60, 2],
	["fog_event", 40, 60, 3],
	["blizzard", 30, 60, 3],
	["laserV2", 20, 60, 3]
]

var next_event:int = 0
var last_events:Array[int] = [-1, -1, -1]


var cooldawn_event:int = 10#40
var active_duration:int

@onready var tree:Node2D = $".."
@onready var spawn_enemy:Node2D = $"../Spawn enemy"
@onready var player = $"../Player"


func _ready() -> void:
	next_event = get_ramdom_event_key()
	tree.updateFrame.connect(frame_next)

func frame_next() -> void:
	if cooldawn_event > 0: 
		if active == false:return
		cooldawn_event -= 1
		active_duration = 0
	else: 
		active_duration += 1
		update_events()


func update_events() -> void:
	call(events[next_event][0])

func finish_event() -> void:
	var temp_next_event:int = get_ramdom_event_key(last_events)

	next_event = temp_next_event

	last_events[0] = last_events[1]
	last_events[1] = last_events[2]
	last_events[2] = next_event

	print(last_events)
	if Global.dificult_max: cooldawn_event = 3
	else: cooldawn_event = randi_range(events[next_event][1], events[next_event][2]-1)


func get_ramdom_event_key(exceptions:Array=[]) -> int: #weights sistem
#exceptions controller
	var event_modified:Array[int] = []
	for i in events: event_modified.append(i[3])
	for i in exceptions: event_modified[i] = 0
#----------------------

	var total_weight:int = 0

	for temp_event in event_modified:
		total_weight += temp_event

	var roll:int = randi() % total_weight
	var cumulative:int = 0

	for i in range(event_modified.size()):
		cumulative += event_modified[i]
		if roll < cumulative:
			return i

	return 0

func died_from_event() -> bool:
	#laser dead
	if jumping == false and laser_activatedV1 == true:return true
	elif jumping == false and laser_down_activated: return true
	elif jumping and laser_up_activated: return true
	
	return false


var jumping:bool = false
func check_jump_for_laser_event() -> void:
	if player.get_jump_axis() and active_duration >= 1:
		jumping = true
		player.get_node("Sprites/AnimationPlayer2").\
		play("moveUp" if next_event == 0  else "moveJustUp")
	elif player.get_hability_axis() and jumping and active_duration >= 5 and next_event == 4:
		player.get_node("Sprites/AnimationPlayer2").play("moveDownInstant")
		jumping = false

	if jumping == true:
		player.move_cooldawn = player.move_cooldawn_max


#region event laser
var laser_activatedV1:bool = false
func laserV1() -> void:
	check_jump_for_laser_event()
	if active_duration == 1:tree.inmortality_cooldawn += 2

	elif active_duration == 2 or active_duration == 3:
		$"../Laser/preparation".play("Laser")
		spawn_enemy.clear_enemys()
		spawn_enemy.active = false

	elif active_duration == 4:
		$"../Laser/Laser/Fire".play("laser")
		laser_activatedV1 = true

	elif active_duration == 5:
		laser_activatedV1 = false
		spawn_enemy.active = true
		finish_event()
#endregion

#region event laserV2
var laser_down_activated:bool = false
var laser_up_activated:bool = false
func laserV2() -> void:
	check_jump_for_laser_event()
	if active_duration == 1:tree.inmortality_cooldawn += 2

	elif active_duration == 2 or active_duration == 3:
		$"../Laser/preparation".play("Laser")
		spawn_enemy.clear_enemys()
		spawn_enemy.active = false

	elif active_duration == 4:
		$"../Laser/Laser/Fire".play("laser")
		laser_down_activated = true
	elif active_duration == 5:
		$"../Laser2/preparation".play("Laser")
		laser_down_activated = false
	elif active_duration == 6:
		$"../Laser2/Laser/Fire".play("Laser")
		laser_up_activated = true
		
	elif active_duration == 7:
		laser_up_activated = false
		laser_down_activated = false
		spawn_enemy.active = true
		finish_event()
#endregion


#region event flip_camera
func flip_camera() -> void:
	if active_duration == 1:
		$"../Camera2D/AnimationPlayer".play("camera_event_start")
		_camera_event_active = true
		spawn_enemy.clear_enemys()
	elif active_duration >= 35:
		$"../Camera2D/AnimationPlayer".play("camera_event_end")
		spawn_enemy.clear_enemys()
		_camera_event_active = false
		finish_event()

var _camera_event_active:bool = false
func get_camera_event_state() -> bool:
	return _camera_event_active
#endregion

#region event fog
func fog_event() -> void:
	if active_duration == 1:$"../Torment/fog".play("Active")
	elif active_duration >= 25:
		$"../Torment/fog".play("Disable")
		finish_event()
#endregion

#region blizzard
@onready var blizzard_particles = [$"../blizzard/CPUParticles2D", $"../blizzard/CPUParticles2D2"]
func blizzard() -> void:
	var _direction_blizzard:int = -1 if active_duration < 15 else 1
	if active_duration == 1:
		_blizard_particles_control(true, false)
	elif active_duration == 30:
		_blizard_particles_control(false, false)
		finish_event()
		return
	elif active_duration >= 15: 
		_blizard_particles_control(false, true)
	for child in $"../Spawn enemy".get_children():
		if child.current_cell == 2 or child.current_cell == 0:
			var next_cell:int = clampi(child.get_cell_x() + _direction_blizzard,0,5)
			child.set_cell_x(next_cell)

func _blizard_particles_control(particles0:bool, particles1:bool) -> void:
	blizzard_particles[0].emitting = particles0
	blizzard_particles[1].emitting = particles1
#endregion

#Time stop
