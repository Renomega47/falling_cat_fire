extends Node2D


const events:Array[Array] = [
	["laser", 40, 70],
	["flip_camera", 40, 70],
	["fog_event", 30, 40],
	["blizzard", 40, 50]
]
var next_event:int = 3

var cooldawn_event:int = 10
var active_duration:int

@onready var tree:Node2D = $".."
@onready var spawn_enemy:Node2D = $"../Spawn enemy"
@onready var player = $"../Player"
func _ready() -> void:
	tree.updateFrame.connect(frame_next)

func frame_next() -> void:
	if cooldawn_event > 0: 
		cooldawn_event -= 1
		active_duration = 0
	else: 
		active_duration += 1
		update_events()

func update_events() -> void:
	call(events[next_event][0])

func finish_event() -> void:
	next_event = randi_range(0, events.size()-1)
	cooldawn_event = randi_range(events[next_event][1], events[next_event][2]-1)

func died_from_event() -> bool:
	#laser dead
	if player.jumping == false and laser_activated == true:return true
	
	
	return false

#region event laser
var laser_activated:bool = false
func laser() -> void:

	if active_duration == 1:tree.inmortality_cooldawn += 2

	elif active_duration == 2 or active_duration == 3:
		$"../Laser/preparation".play("Laser")
		spawn_enemy.clear_enemys()
		spawn_enemy.active = false

	elif active_duration == 4:
		$"../Laser/Laser/Fire".play("laser")
		laser_activated = true

	elif active_duration == 5:
		laser_activated = false
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

func fog_event() -> void:
	if active_duration == 1:$"../Torment/fog".play("Active")
	elif active_duration >= 25:
		$"../Torment/fog".play("Disable")
		finish_event()

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
